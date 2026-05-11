Describe 'T-01 scaffold' {
    Context 'CA-01: scaffold structure and bootstrap contracts' {
        It 'should create the expected root files when the workspace scaffold is initialized' {
            $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
            $expectedFiles = @(
                'FomOracle.sln',
                'package.json',
                'pnpm-workspace.yaml',
                'README.md'
            )

            foreach ($relativePath in $expectedFiles) {
                $fullPath = Join-Path $repoRoot $relativePath

                if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
                    throw "Expected root file '$relativePath' to exist."
                }
            }
        }

        It 'should create the expected frontend and backend directories when the workspace scaffold is initialized' {
            $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
            $expectedDirectories = @(
                'frontend/src/app',
                'frontend/src/features',
                'frontend/src/shared',
                'backend/src',
                'backend/tests'
            )

            foreach ($relativePath in $expectedDirectories) {
                $fullPath = Join-Path $repoRoot $relativePath

                if (-not (Test-Path -LiteralPath $fullPath -PathType Container)) {
                    throw "Expected directory '$relativePath' to exist."
                }
            }
        }

        It 'should expose a runnable T-01 test script in the root package manifest' {
            $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
            $packageJsonPath = Join-Path $repoRoot 'package.json'
            $packageJson = Get-Content -LiteralPath $packageJsonPath -Raw | ConvertFrom-Json

            $expectedScript = 'pwsh -NoProfile -ExecutionPolicy Bypass -File ./scripts/run-t01-tests.ps1'
            if ($packageJson.scripts.'test:t01' -ne $expectedScript) {
                throw "Expected test:t01 script to be '$expectedScript'."
            }
        }
    }

    Context 'CA-01: backend bootstrap fail-fast behavior' {
        It 'should fail with a clear error when the solution file is missing' {
            $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
            $sandboxRoot = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
            $scriptsDir = Join-Path $sandboxRoot 'scripts'

            New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
            Copy-Item -LiteralPath (Join-Path $repoRoot 'scripts/bootstrap-backend.ps1') -Destination (Join-Path $scriptsDir 'bootstrap-backend.ps1')

            try {
                $scriptPath = Join-Path $scriptsDir 'bootstrap-backend.ps1'
                $stdoutPath = Join-Path $sandboxRoot 'bootstrap.stdout.log'
                $stderrPath = Join-Path $sandboxRoot 'bootstrap.stderr.log'

                $process = Start-Process -FilePath 'pwsh' `
                    -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $scriptPath) `
                    -RedirectStandardOutput $stdoutPath `
                    -RedirectStandardError $stderrPath `
                    -Wait `
                    -PassThru

                $output = (Get-Content -LiteralPath $stdoutPath -Raw -ErrorAction SilentlyContinue) +
                    (Get-Content -LiteralPath $stderrPath -Raw -ErrorAction SilentlyContinue)

                if ($process.ExitCode -ne 1) {
                    throw "Expected exit code 1, got $($process.ExitCode)."
                }

                if ($output -notmatch 'solution nao encontrada') {
                    throw "Expected missing solution error. Output: $output"
                }
            }
            finally {
                Remove-Item -LiteralPath $sandboxRoot -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        It 'should fail with a clear error when the solution contains no restorable projects' {
            $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
            $sandboxRoot = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
            $scriptsDir = Join-Path $sandboxRoot 'scripts'

            New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
            Copy-Item -LiteralPath (Join-Path $repoRoot 'scripts/bootstrap-backend.ps1') -Destination (Join-Path $scriptsDir 'bootstrap-backend.ps1')
            Set-Content -LiteralPath (Join-Path $sandboxRoot 'FomOracle.sln') -Value ''

            try {
                $scriptPath = Join-Path $scriptsDir 'bootstrap-backend.ps1'
                $stdoutPath = Join-Path $sandboxRoot 'bootstrap.stdout.log'
                $stderrPath = Join-Path $sandboxRoot 'bootstrap.stderr.log'

                $process = Start-Process -FilePath 'pwsh' `
                    -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $scriptPath) `
                    -RedirectStandardOutput $stdoutPath `
                    -RedirectStandardError $stderrPath `
                    -Wait `
                    -PassThru

                $output = (Get-Content -LiteralPath $stdoutPath -Raw -ErrorAction SilentlyContinue) +
                    (Get-Content -LiteralPath $stderrPath -Raw -ErrorAction SilentlyContinue)

                if ($process.ExitCode -ne 1) {
                    throw "Expected exit code 1, got $($process.ExitCode)."
                }

                if ($output -notmatch 'projetos') {
                    throw "Expected project count error. Output: $output"
                }

                if ($output -notmatch 'restauraveis') {
                    throw "Expected restorable projects error. Output: $output"
                }
            }
            finally {
                Remove-Item -LiteralPath $sandboxRoot -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        It 'should fail fast for the current T-01 repository state when the solution is still empty' {
            $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
            $scriptPath = Join-Path $repoRoot 'scripts/bootstrap-backend.ps1'
            $sandboxRoot = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
            $stdoutPath = Join-Path $sandboxRoot 'bootstrap.stdout.log'
            $stderrPath = Join-Path $sandboxRoot 'bootstrap.stderr.log'

            try {
                New-Item -ItemType Directory -Path $sandboxRoot -Force | Out-Null

                $process = Start-Process -FilePath 'pwsh' `
                    -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $scriptPath) `
                    -RedirectStandardOutput $stdoutPath `
                    -RedirectStandardError $stderrPath `
                    -Wait `
                    -PassThru

                $output = (Get-Content -LiteralPath $stdoutPath -Raw -ErrorAction SilentlyContinue) +
                    (Get-Content -LiteralPath $stderrPath -Raw -ErrorAction SilentlyContinue)

                if ($process.ExitCode -ne 1) {
                    throw "Expected exit code 1, got $($process.ExitCode)."
                }

                if ($output -notmatch 'Isso e\s+esperado na T-01') {
                    throw "Expected T-01 empty solution guidance. Output: $output"
                }
            }
            finally {
                Remove-Item -LiteralPath $sandboxRoot -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

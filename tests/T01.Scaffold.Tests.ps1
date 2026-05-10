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

                Test-Path -LiteralPath $fullPath | Should Be $true
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

                Test-Path -LiteralPath $fullPath -PathType Container | Should Be $true
            }
        }

        It 'should expose a runnable T-01 test script in the root package manifest' {
            $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
            $packageJsonPath = Join-Path $repoRoot 'package.json'
            $packageJson = Get-Content -LiteralPath $packageJsonPath -Raw | ConvertFrom-Json

            $packageJson.scripts.'test:t01' | Should Be 'pwsh -ExecutionPolicy Bypass -File ./scripts/run-t01-tests.ps1'
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

                $process.ExitCode | Should Be 1
                ($output -match 'solution nao encontrada') | Should Be $true
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

                $process.ExitCode | Should Be 1
                ($output -match 'projetos') | Should Be $true
                ($output -match 'restauraveis') | Should Be $true
            }
            finally {
                Remove-Item -LiteralPath $sandboxRoot -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        It 'should fail fast for the current T-01 repository state when the solution is still empty' {
            $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
            $scriptPath = Join-Path $repoRoot 'scripts/bootstrap-backend.ps1'
            $stdoutPath = Join-Path $repoRoot 'bootstrap.stdout.log'
            $stderrPath = Join-Path $repoRoot 'bootstrap.stderr.log'

            try {
                $process = Start-Process -FilePath 'pwsh' `
                    -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $scriptPath) `
                    -RedirectStandardOutput $stdoutPath `
                    -RedirectStandardError $stderrPath `
                    -Wait `
                    -PassThru

                $output = (Get-Content -LiteralPath $stdoutPath -Raw -ErrorAction SilentlyContinue) +
                    (Get-Content -LiteralPath $stderrPath -Raw -ErrorAction SilentlyContinue)

                $process.ExitCode | Should Be 1
                ($output -match 'Isso e\s+esperado na T-01') | Should Be $true
            }
            finally {
                Remove-Item -LiteralPath $stdoutPath -ErrorAction SilentlyContinue
                Remove-Item -LiteralPath $stderrPath -ErrorAction SilentlyContinue
            }
        }
    }
}

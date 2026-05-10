function Invoke-BootstrapScript {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptRoot
    )

    $scriptPath = Join-Path $ScriptRoot 'scripts\bootstrap-backend.ps1'
    $stdoutPath = Join-Path $ScriptRoot 'bootstrap.stdout.log'
    $stderrPath = Join-Path $ScriptRoot 'bootstrap.stderr.log'

    $process = Start-Process -FilePath 'pwsh' `
        -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $scriptPath) `
        -RedirectStandardOutput $stdoutPath `
        -RedirectStandardError $stderrPath `
        -Wait `
        -PassThru

    $stdout = if (Test-Path -LiteralPath $stdoutPath) {
        Get-Content -LiteralPath $stdoutPath -Raw
    }
    else {
        ''
    }

    $stderr = if (Test-Path -LiteralPath $stderrPath) {
        Get-Content -LiteralPath $stderrPath -Raw
    }
    else {
        ''
    }

    Remove-Item -LiteralPath $stdoutPath -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $stderrPath -ErrorAction SilentlyContinue

    [pscustomobject]@{
        ExitCode = $process.ExitCode
        Output   = ($stdout + $stderr)
    }
}

function New-BootstrapSandbox {
    $sandboxRoot = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
    $scriptsDir = Join-Path $sandboxRoot 'scripts'

    New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot '..\scripts\bootstrap-backend.ps1') -Destination (Join-Path $scriptsDir 'bootstrap-backend.ps1')

    $sandboxRoot
}

Describe 'T-01 scaffold' {
    $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))

    Context 'CA-01: scaffold structure and bootstrap contracts' {
        It 'should create the expected root files when the workspace scaffold is initialized' {
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
            $expectedDirectories = @(
                'frontend\src\app',
                'frontend\src\features',
                'frontend\src\shared',
                'backend\src',
                'backend\tests'
            )

            foreach ($relativePath in $expectedDirectories) {
                $fullPath = Join-Path $repoRoot $relativePath

                Test-Path -LiteralPath $fullPath -PathType Container | Should Be $true
            }
        }

        It 'should expose a runnable T-01 test script in the root package manifest' {
            $packageJsonPath = Join-Path $repoRoot 'package.json'
            $packageJson = Get-Content -LiteralPath $packageJsonPath -Raw | ConvertFrom-Json

            $packageJson.scripts.'test:t01' | Should Be 'pwsh -ExecutionPolicy Bypass -File ./scripts/run-t01-tests.ps1'
        }
    }

    Context 'CA-01: backend bootstrap fail-fast behavior' {
        It 'should fail with a clear error when the solution file is missing' {
            $sandboxRoot = New-BootstrapSandbox

            try {
                $result = Invoke-BootstrapScript -ScriptRoot $sandboxRoot

                $result.ExitCode | Should Be 1
                ($result.Output -match 'solution nao encontrada') | Should Be $true
            }
            finally {
                Remove-Item -LiteralPath $sandboxRoot -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        It 'should fail with a clear error when the solution contains no restorable projects' {
            $sandboxRoot = New-BootstrapSandbox

            try {
                Set-Content -LiteralPath (Join-Path $sandboxRoot 'FomOracle.sln') -Value ''
                $result = Invoke-BootstrapScript -ScriptRoot $sandboxRoot

                $result.ExitCode | Should Be 1
                ($result.Output -match 'projetos') | Should Be $true
                ($result.Output -match 'restauraveis') | Should Be $true
            }
            finally {
                Remove-Item -LiteralPath $sandboxRoot -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        It 'should fail fast for the current T-01 repository state when the solution is still empty' {
            $result = Invoke-BootstrapScript -ScriptRoot $repoRoot

            $result.ExitCode | Should Be 1
            ($result.Output -match 'Isso e\s+esperado na T-01') | Should Be $true
        }
    }
}

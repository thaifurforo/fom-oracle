$ErrorActionPreference = 'Stop'

$pesterModule = Get-Module -ListAvailable Pester | Sort-Object Version -Descending | Select-Object -First 1

if (-not $pesterModule) {
    throw "Pester nao esta instalado. Instale o modulo Pester para executar os testes da T-01."
}

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$testScriptPath = Join-Path $repoRoot 'tests/T01.Scaffold.Tests.ps1'
$testScriptPath = [System.IO.Path]::GetFullPath($testScriptPath)

if (-not (Test-Path -LiteralPath $testScriptPath)) {
    throw "Arquivo de teste nao encontrado em '$testScriptPath'."
}

Import-Module $pesterModule.Path -Force
$invokePesterParameters = @{
    PassThru = $true
}

if ($pesterModule.Version.Major -ge 5) {
    $invokePesterParameters.Path = $testScriptPath
} else {
    $invokePesterParameters.Script = $testScriptPath
}

$result = Invoke-Pester @invokePesterParameters

if ($result.FailedCount -gt 0) {
    exit 1
}

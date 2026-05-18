$ErrorActionPreference = 'Stop'

$pesterModule = Get-Module -ListAvailable Pester | Sort-Object Version -Descending | Select-Object -First 1

if (-not $pesterModule) {
    throw "Pester não está instalado. Instale o módulo Pester para executar os testes de governança de design."
}

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$testScriptPath = Join-Path $repoRoot 'tests/FrontendDesignGovernance.Tests.ps1'
$testScriptPath = [System.IO.Path]::GetFullPath($testScriptPath)

if (-not (Test-Path -LiteralPath $testScriptPath)) {
    throw "Arquivo de teste não encontrado em '$testScriptPath'."
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

$ErrorActionPreference = 'Stop'

$pesterModule = Get-Module -ListAvailable Pester | Sort-Object Version -Descending | Select-Object -First 1

if (-not $pesterModule) {
    Write-Error "Pester nao esta instalado. Instale o modulo Pester para executar os testes da T-01."
}

$testScriptPath = Join-Path $PSScriptRoot '..\tests\T01.Scaffold.Tests.ps1'
$testScriptPath = [System.IO.Path]::GetFullPath($testScriptPath)

if (-not (Test-Path -LiteralPath $testScriptPath)) {
    Write-Error "Arquivo de teste nao encontrado em '$testScriptPath'."
}

Import-Module $pesterModule.Path -Force
$result = Invoke-Pester -Script $testScriptPath -PassThru

if ($result.FailedCount -gt 0) {
    exit 1
}

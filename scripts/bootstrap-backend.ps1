$ErrorActionPreference = 'Stop'

$solutionPath = Join-Path $PSScriptRoot '..\\FomOracle.sln'
$solutionPath = [System.IO.Path]::GetFullPath($solutionPath)

if (-not (Test-Path -LiteralPath $solutionPath)) {
    Write-Error "Bootstrap abortado: solution nao encontrada em '$solutionPath'."
}

$solutionContents = Get-Content -LiteralPath $solutionPath -Raw
$projectMatches = [regex]::Matches($solutionContents, 'Project\(')

if ($projectMatches.Count -eq 0) {
    Write-Error "Bootstrap abortado: a solution '$solutionPath' ainda nao contem projetos restauraveis. Isso e esperado na T-01; adicione projetos reais na T-03 antes de executar o restore do backend."
}

dotnet restore $solutionPath

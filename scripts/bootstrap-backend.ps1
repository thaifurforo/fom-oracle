$ErrorActionPreference = 'Stop'

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$solutionPath = Join-Path $repoRoot 'FomOracle.sln'
$solutionPath = [System.IO.Path]::GetFullPath($solutionPath)

if (-not (Test-Path -LiteralPath $solutionPath)) {
    throw "Bootstrap abortado: solution nao encontrada em '$solutionPath'."
}

$solutionContents = Get-Content -LiteralPath $solutionPath -Raw
$projectMatches = [regex]::Matches(
    $solutionContents,
    '^\s*Project\("[^"]+"\)\s*=\s*"[^"]+",\s*"([^"]+\.(?:csproj|fsproj|vbproj))",',
    [System.Text.RegularExpressions.RegexOptions]::Multiline
)

if ($projectMatches.Count -eq 0) {
    throw "Bootstrap abortado: a solution '$solutionPath' ainda nao contem projetos restauraveis. Isso e esperado na T-01; adicione projetos reais na T-03 antes de executar o restore do backend."
}

dotnet restore $solutionPath
if ($LASTEXITCODE -ne 0) {
    throw "Bootstrap abortado: dotnet restore falhou com exit code $LASTEXITCODE."
}

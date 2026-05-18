param(
    [string]$PullRequestBody = $env:PR_BODY,
    [string]$ChangedFilesPath = 'changed_files.txt',
    [string]$RepositoryRoot = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

function Test-FrontendDesignGovernanceNeeded {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$ChangedFiles
    )

    $governedPathPattern = '^(frontend/|DESIGN\.md$|\.catalog/prototypes/)'

    foreach ($path in $ChangedFiles) {
        $normalizedPath = $path -replace '\\', '/'
        if ($normalizedPath -match $governedPathPattern) {
            return $true
        }
    }

    return $false
}

function Test-DesignGuideChanged {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$ChangedFiles
    )

    foreach ($path in $ChangedFiles) {
        $normalizedPath = $path -replace '\\', '/'
        if ($normalizedPath -eq 'DESIGN.md') {
            return $true
        }
    }

    return $false
}

function Get-MarkdownSectionBody {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Markdown,

        [Parameter(Mandatory = $true)]
        [string]$SectionTitle
    )

    $escapedTitle = [regex]::Escape($SectionTitle)
    $pattern = "(?ims)^#{2,}\s*$escapedTitle[^\r\n]*\r?\n(?<body>.*?)(?=^#{1,}\s+|\z)"
    $match = [regex]::Match($Markdown, $pattern)

    if (-not $match.Success) {
        return $null
    }

    return $match.Groups['body'].Value.Trim()
}

function Get-VisualEvidenceSectionBody {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Markdown
    )

    $pattern = "(?ims)^#{2,}\s*Evid[eê]ncia visual[^\r\n]*\r?\n(?<body>.*?)(?=^#{1,}\s+|\z)"
    $match = [regex]::Match($Markdown, $pattern)

    if (-not $match.Success) {
        return $null
    }

    return $match.Groups['body'].Value.Trim()
}

function Assert-VisualEvidenceSectionFilled {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$PullRequestBody
    )

    $sectionBody = Get-VisualEvidenceSectionBody -Markdown $PullRequestBody

    if ([string]::IsNullOrWhiteSpace($sectionBody)) {
        throw 'Seção Evidência visual deve incluir print, gravação ou justificativa explícita de ausência de impacto visual.'
    }

    $templateOnlyPattern = '(?ims)^\s*-\s*Inclua prints ou fluxo gravado curto demonstrando a mudança de interface\.\s*-\s*Explique rapidamente o que cada evidência comprova\.\s*-\s*Se não houver impacto visual, justificar explicitamente\.\s*$'
    if ($sectionBody -match $templateOnlyPattern) {
        throw 'Seção Evidência visual deve incluir print, gravação ou justificativa explícita de ausência de impacto visual.'
    }
}

function Assert-DesignGuideImpactSectionFilled {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$PullRequestBody
    )

    $sectionBody = Get-MarkdownSectionBody -Markdown $PullRequestBody -SectionTitle 'Impacto no DESIGN.md'

    if ([string]::IsNullOrWhiteSpace($sectionBody)) {
        throw 'Mudanças no DESIGN.md devem preencher a seção Impacto no DESIGN.md.'
    }

    $noImpactChecked = $sectionBody -match '(?im)^-\s*\[[xX]\]\s+Sem impacto no guia; esta PR apenas aplica padrões existentes\.'
    $withImpactChecked = $sectionBody -match '(?im)^-\s*\[[xX]\]\s+Com impacto no guia; atualizei o `?DESIGN\.md`? nesta PR\.'

    if (-not $noImpactChecked -and -not $withImpactChecked) {
        throw 'Mudanças no DESIGN.md devem marcar uma opção de impacto no guia.'
    }

    if ($noImpactChecked -and $withImpactChecked) {
        throw 'Mudanças no DESIGN.md devem marcar apenas uma opção de impacto no guia.'
    }

    if ($withImpactChecked) {
        $summaryMatch = [regex]::Match($sectionBody, '(?im)^-\s*Resumo do impacto:\s*(?<summary>.+)$')
        $summary = $summaryMatch.Groups['summary'].Value.Trim()

        if (-not $summaryMatch.Success -or [string]::IsNullOrWhiteSpace($summary) -or $summary -match '^<!--.*-->$') {
            throw 'Resumo do impacto no DESIGN.md deve descrever a mudança aplicada ao guia.'
        }
    }
}

function Assert-PullRequestDesignGovernance {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$PullRequestBody,

        [Parameter(Mandatory = $true)]
        [string[]]$ChangedFiles
    )

    if (-not (Test-FrontendDesignGovernanceNeeded -ChangedFiles $ChangedFiles)) {
        return
    }

    if ([string]::IsNullOrWhiteSpace($PullRequestBody)) {
        throw 'PR com mudança de frontend/UI deve preencher a descrição com aderência ao DESIGN.md e evidência visual.'
    }

    if ($PullRequestBody -notmatch '(?im)^#{2,}\s*Ader[eê]ncia ao DESIGN\.md') {
        throw 'Falta seção obrigatória de aderência ao DESIGN.md.'
    }

    if ($PullRequestBody -notmatch '(?im)^#{2,}\s*Evid[eê]ncia visual') {
        throw 'Falta seção obrigatória de evidência visual para mudança de frontend/UI.'
    }

    Assert-VisualEvidenceSectionFilled -PullRequestBody $PullRequestBody

    if ($PullRequestBody -notmatch '(?im)^-\s*\[[xX]\]\s+Li e apliquei o `?DESIGN\.md`? nas decisões de UI/UX e arquitetura de interface desta PR\.') {
        throw 'Checklist de aderência ao DESIGN.md não marcado.'
    }

    if (Test-DesignGuideChanged -ChangedFiles $ChangedFiles) {
        if ($PullRequestBody -notmatch '(?im)^#{2,}\s*Impacto no DESIGN\.md') {
            throw 'Mudanças no DESIGN.md devem preencher a seção Impacto no DESIGN.md.'
        }

        Assert-DesignGuideImpactSectionFilled -PullRequestBody $PullRequestBody
    }
}

function Get-FrontendRuntimeFiles {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot
    )

    $frontendRoot = Join-Path $RepositoryRoot 'frontend'
    if (-not (Test-Path -LiteralPath $frontendRoot -PathType Container)) {
        return @()
    }

    $extensions = @('.ts', '.tsx', '.js', '.jsx', '.css', '.scss', '.html')
    return @(Get-ChildItem -LiteralPath $frontendRoot -Recurse -File |
        Where-Object {
            $relativePath = [System.IO.Path]::GetRelativePath($frontendRoot, $_.FullName) -replace '\\', '/'
            $extensions -contains $_.Extension.ToLowerInvariant() -and
            $relativePath -notmatch '(^|/)(node_modules|dist|build|coverage|TestResults|__tests__|fixtures?)/' -and
            $relativePath -notmatch '(^|/)[^/]+\.(test|spec)\.[^.]+$'
        })
}

function Assert-FrontendDesignBoundaries {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot
    )

    $forbiddenPatterns = @(
        @{
            Pattern = '(?i)\.catalog/(assets/concept-art|prototypes)|concept-art'
            Message = 'Frontend não pode importar concept art ou protótipos HTML como asset de runtime/UI/bundle.'
        },
        @{
            Pattern = '(?i)(from\s+[''"](?:node:)?fs(?:/promises)?[''"]|require\([''"](?:node:)?fs(?:/promises)?[''"]\)|@tauri-apps/plugin-fs|readTextFile|writeTextFile|BaseDirectory)'
            Message = 'Frontend não pode acessar filesystem diretamente; use a Local API do sidecar.'
        },
        @{
            Pattern = '(?i)(better-sqlite3|sqlite3|sql\.js|\.sqlite\b|\.db\b)'
            Message = 'Frontend não pode acessar SQLite diretamente; persistência local pertence ao core.'
        },
        @{
            Pattern = '(?i)(parseSave|saveParser|save parsing|parser de save|parsing de save)'
            Message = 'Frontend não pode implementar parsing de save; essa regra pertence ao core .NET.'
        }
    )

    foreach ($file in (Get-FrontendRuntimeFiles -RepositoryRoot $RepositoryRoot)) {
        $content = Get-Content -LiteralPath $file.FullName -Raw
        foreach ($rule in $forbiddenPatterns) {
            if ($content -match $rule.Pattern) {
                $relativePath = [System.IO.Path]::GetRelativePath($RepositoryRoot, $file.FullName) -replace '\\', '/'
                throw "$($rule.Message) Arquivo: $relativePath"
            }
        }
    }
}

function Assert-FrontendDesignGovernance {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$PullRequestBody,

        [Parameter(Mandatory = $true)]
        [string[]]$ChangedFiles,

        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot
    )

    Assert-PullRequestDesignGovernance -PullRequestBody $PullRequestBody -ChangedFiles $ChangedFiles
    Assert-FrontendDesignBoundaries -RepositoryRoot $RepositoryRoot
}

function Invoke-FrontendDesignGovernanceValidation {
    param(
        [string]$PullRequestBody,
        [string]$ChangedFilesPath,
        [string]$RepositoryRoot
    )

    if (-not (Test-Path -LiteralPath $ChangedFilesPath -PathType Leaf)) {
        throw "Arquivo de mudanças não encontrado: $ChangedFilesPath"
    }

    $changedFiles = @(Get-Content -LiteralPath $ChangedFilesPath | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    if (-not (Test-FrontendDesignGovernanceNeeded -ChangedFiles $changedFiles)) {
        Write-Host 'Sem mudanças de frontend/UI governadas por DESIGN.md. Gate ignorado.'
        return
    }

    Assert-FrontendDesignGovernance `
        -PullRequestBody $PullRequestBody `
        -ChangedFiles $changedFiles `
        -RepositoryRoot $RepositoryRoot

    Write-Host 'Governança de DESIGN.md validada.'
}

if ($MyInvocation.InvocationName -ne '.') {
    Invoke-FrontendDesignGovernanceValidation `
        -PullRequestBody $PullRequestBody `
        -ChangedFilesPath $ChangedFilesPath `
        -RepositoryRoot $RepositoryRoot
}

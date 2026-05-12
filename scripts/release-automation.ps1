param(
    [ValidateSet('ValidatePullRequest', 'PublishMergedPullRequest')]
    [string]$Mode,
    [int]$PullRequestNumber,
    [string]$Repository = 'thaifurforo/fom-oracle',
    [string]$TargetCommitish = 'main'
)

$ErrorActionPreference = 'Stop'

$ReleaseImpactLabels = @('release:patch', 'release:minor', 'release:major')

function ConvertTo-ReleaseVersion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version
    )

    if ($Version -notmatch '^v(?<Major>0|[1-9]\d*)\.(?<Minor>0|[1-9]\d*)\.(?<Patch>0|[1-9]\d*)$') {
        throw "Release version must use vMAJOR.MINOR.PATCH format: $Version"
    }

    return [pscustomobject]@{
        Version = $Version
        Major = [int]$Matches.Major
        Minor = [int]$Matches.Minor
        Patch = [int]$Matches.Patch
    }
}

function Compare-ReleaseVersion {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Left,
        [Parameter(Mandatory = $true)]
        [object]$Right
    )

    foreach ($part in @('Major', 'Minor', 'Patch')) {
        if ($Left.$part -lt $Right.$part) {
            return -1
        }

        if ($Left.$part -gt $Right.$part) {
            return 1
        }
    }

    return 0
}

function Get-ObjectValue {
    param(
        [Parameter(Mandatory = $true)]
        [object]$InputObject,
        [Parameter(Mandatory = $true)]
        [string[]]$Names
    )

    foreach ($name in $Names) {
        if ($InputObject -is [hashtable] -and $InputObject.ContainsKey($name)) {
            return $InputObject[$name]
        }

        $property = $InputObject.PSObject.Properties[$name]
        if ($null -ne $property) {
            return $property.Value
        }
    }

    return $null
}

function Get-LabelNames {
    param(
        [object[]]$Labels = @()
    )

    return @(
        $Labels |
            ForEach-Object {
                if ($_ -is [string]) {
                    $_
                } else {
                    Get-ObjectValue -InputObject $_ -Names @('name')
                }
            } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    )
}

function Get-ReleaseImpactLabels {
    param(
        [object[]]$Labels = @()
    )

    $labelNames = Get-LabelNames -Labels $Labels
    return @($labelNames | Where-Object { $ReleaseImpactLabels -contains $_ })
}

function Get-ClosingIssueNumbers {
    param(
        [string]$Body
    )

    if ([string]::IsNullOrWhiteSpace($Body)) {
        return @()
    }

    $pattern = '(?im)\b(close[sd]?|fix(e[sd])?|resolve[sd]?)\s+((?:[\w.-]+/[\w.-]+)?#(?<Number>\d+))'
    $matches = [regex]::Matches($Body, $pattern)

    return @(
        $matches |
            ForEach-Object { [int]$_.Groups['Number'].Value } |
            Select-Object -Unique
    )
}

function Assert-ReleasePullRequest {
    param(
        [Parameter(Mandatory = $true)]
        [object]$PullRequest,
        [int[]]$ExistingIssueNumbers = @()
    )

    $body = [string](Get-ObjectValue -InputObject $PullRequest -Names @('body'))
    $issueNumbers = @(Get-ClosingIssueNumbers -Body $body)
    if ($issueNumbers.Count -eq 0) {
        throw 'Pull request body must include a closing keyword for at least one issue.'
    }

    $labels = Get-ObjectValue -InputObject $PullRequest -Names @('labels')
    $impactLabels = @(Get-ReleaseImpactLabels -Labels @($labels))
    if ($impactLabels.Count -ne 1) {
        throw 'Pull request must have exactly one release impact label: release:patch, release:minor, or release:major.'
    }

    $missingIssues = @($issueNumbers | Where-Object { $ExistingIssueNumbers -notcontains $_ })
    if ($missingIssues.Count -gt 0) {
        $formattedIssues = ($missingIssues | ForEach-Object { "#$_" }) -join ', '
        throw "Pull request references issue(s) not found in this repository: $formattedIssues"
    }
}

function Get-PullRequestImpactLabel {
    param(
        [Parameter(Mandatory = $true)]
        [object]$PullRequest
    )

    $labels = Get-ObjectValue -InputObject $PullRequest -Names @('labels')
    $impactLabels = @(Get-ReleaseImpactLabels -Labels @($labels))
    if ($impactLabels.Count -ne 1) {
        throw 'Pull request must have exactly one release impact label: release:patch, release:minor, or release:major.'
    }

    return $impactLabels[0]
}

function Get-LatestSemVerReleaseTag {
    param(
        [object[]]$Releases = @()
    )

    $latest = $null
    foreach ($release in $Releases) {
        $isDraft = [bool](Get-ObjectValue -InputObject $release -Names @('isDraft', 'draft'))
        if ($isDraft) {
            continue
        }

        $tagName = [string](Get-ObjectValue -InputObject $release -Names @('tagName', 'tag_name'))
        if ([string]::IsNullOrWhiteSpace($tagName)) {
            continue
        }

        try {
            $parsed = ConvertTo-ReleaseVersion -Version $tagName
        } catch {
            continue
        }

        if ($null -eq $latest -or (Compare-ReleaseVersion -Left $parsed -Right $latest) -gt 0) {
            $latest = $parsed
        }
    }

    if ($null -eq $latest) {
        return 'v0.0.0'
    }

    return $latest.Version
}

function Get-NextReleaseVersion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CurrentVersion,
        [Parameter(Mandatory = $true)]
        [string]$ImpactLabel
    )

    $parsed = ConvertTo-ReleaseVersion -Version $CurrentVersion
    switch ($ImpactLabel) {
        'release:patch' {
            return "v$($parsed.Major).$($parsed.Minor).$($parsed.Patch + 1)"
        }
        'release:minor' {
            return "v$($parsed.Major).$($parsed.Minor + 1).0"
        }
        'release:major' {
            return "v$($parsed.Major + 1).0.0"
        }
        default {
            throw "Unsupported release impact label: $ImpactLabel"
        }
    }
}

function New-IssueImpactLabelRequests {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Repository,
        [int[]]$IssueNumbers = @(),
        [Parameter(Mandatory = $true)]
        [string]$ImpactLabel
    )

    return @(
        $IssueNumbers |
            ForEach-Object {
                [pscustomobject]@{
                    Endpoint = "repos/$Repository/issues/$_/labels"
                    Method = 'POST'
                    Payload = @{ labels = @($ImpactLabel) }
                }
            }
    )
}

function New-JsonTempFile {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Payload
    )

    $tempRoot = $env:RUNNER_TEMP
    if ([string]::IsNullOrWhiteSpace($tempRoot)) {
        $tempRoot = $env:TEMP
    }

    $path = Join-Path $tempRoot ("release-payload-" + [guid]::NewGuid().ToString() + ".json")
    $Payload | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $path -Encoding UTF8
    return $path
}

function Invoke-GhJson {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments,
        [bool]$AllowFailure = $false
    )

    $output = & gh @Arguments
    if ($LASTEXITCODE -ne 0) {
        if ($AllowFailure) {
            return $null
        }

        throw "gh $($Arguments -join ' ') failed."
    }

    if ([string]::IsNullOrWhiteSpace($output)) {
        return $null
    }

    return ($output -join "`n") | ConvertFrom-Json
}

function Invoke-GhApiWithJsonBody {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Endpoint,
        [Parameter(Mandatory = $true)]
        [string]$Method,
        [Parameter(Mandatory = $true)]
        [hashtable]$Payload
    )

    $payloadFile = New-JsonTempFile -Payload $Payload
    try {
        return Invoke-GhJson -Arguments @('api', $Endpoint, '--method', $Method, '--input', $payloadFile)
    } finally {
        if (Test-Path -LiteralPath $payloadFile) {
            Remove-Item -LiteralPath $payloadFile -Force
        }
    }
}

function Get-PullRequestFromGitHub {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Repository,
        [Parameter(Mandatory = $true)]
        [int]$PullRequestNumber
    )

    return Invoke-GhJson -Arguments @('pr', 'view', ([string]$PullRequestNumber), '--repo', $Repository, '--json', 'number,body,labels,title')
}

function Test-IssueExistsInRepository {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Repository,
        [Parameter(Mandatory = $true)]
        [int]$IssueNumber
    )

    $issue = Invoke-GhJson -Arguments @('api', "repos/$Repository/issues/$IssueNumber") -AllowFailure $true
    if ($null -eq $issue) {
        return $false
    }

    $pullRequestProperty = $issue.PSObject.Properties['pull_request']
    return ($null -eq $pullRequestProperty)
}

function Get-ExistingIssueNumbersFromGitHub {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Repository,
        [int[]]$IssueNumbers = @()
    )

    return @(
        $IssueNumbers |
            Where-Object { Test-IssueExistsInRepository -Repository $Repository -IssueNumber $_ }
    )
}

function Get-ReleaseNotesFromGitHub {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Repository,
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [Parameter(Mandatory = $true)]
        [string]$TargetCommitish,
        [Parameter(Mandatory = $true)]
        [string]$PreviousTag,
        [Parameter(Mandatory = $true)]
        [string]$ImpactLabel,
        [int[]]$IssueNumbers = @()
    )

    $payload = @{
        tag_name = $Version
        target_commitish = $TargetCommitish
        configuration_file_path = '.github/release.yml'
    }

    if ($PreviousTag -ne 'v0.0.0') {
        $payload.previous_tag_name = $PreviousTag
    }

    $generated = Invoke-GhApiWithJsonBody -Endpoint "repos/$Repository/releases/generate-notes" -Method 'POST' -Payload $payload
    $issueText = if ($IssueNumbers.Count -gt 0) { ($IssueNumbers | ForEach-Object { "#$_" }) -join ', ' } else { 'nenhuma' }
    $gate = @(
        '## Automação de Release'
        ''
        ('- Impacto: `' + $ImpactLabel + '`')
        "- Issues vinculadas: $issueText"
        '- Publicado a partir de um PR mesclado em `main`'
    ) -join "`n"

    return "$gate`n`n$($generated.body)"
}

function New-ReleaseCreatePayload {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [Parameter(Mandatory = $true)]
        [string]$ReleaseNotes,
        [Parameter(Mandatory = $true)]
        [string]$TargetCommitish
    )

    $parsed = ConvertTo-ReleaseVersion -Version $Version
    $isStable = $parsed.Major -ge 1

    return @{
        tag_name = $Version
        target_commitish = $TargetCommitish
        name = $Version
        body = $ReleaseNotes
        draft = $false
        prerelease = (-not $isStable)
        make_latest = if ($isStable) { 'true' } else { 'false' }
    }
}

function Invoke-ValidatePullRequestCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Repository,
        [Parameter(Mandatory = $true)]
        [int]$PullRequestNumber
    )

    $pullRequest = Get-PullRequestFromGitHub -Repository $Repository -PullRequestNumber $PullRequestNumber
    $issueNumbers = @(Get-ClosingIssueNumbers -Body ([string]$pullRequest.body))
    $existingIssueNumbers = @(Get-ExistingIssueNumbersFromGitHub -Repository $Repository -IssueNumbers $issueNumbers)
    Assert-ReleasePullRequest -PullRequest $pullRequest -ExistingIssueNumbers $existingIssueNumbers

    Write-Host "Pull request #$PullRequestNumber is linked to issue(s) $($issueNumbers -join ', ') and has release impact $(Get-PullRequestImpactLabel -PullRequest $pullRequest)."
}

function Invoke-PublishMergedPullRequestCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Repository,
        [Parameter(Mandatory = $true)]
        [int]$PullRequestNumber,
        [Parameter(Mandatory = $true)]
        [string]$TargetCommitish
    )

    $pullRequest = Get-PullRequestFromGitHub -Repository $Repository -PullRequestNumber $PullRequestNumber
    $issueNumbers = @(Get-ClosingIssueNumbers -Body ([string]$pullRequest.body))
    $existingIssueNumbers = @(Get-ExistingIssueNumbersFromGitHub -Repository $Repository -IssueNumbers $issueNumbers)
    Assert-ReleasePullRequest -PullRequest $pullRequest -ExistingIssueNumbers $existingIssueNumbers
    $impactLabel = Get-PullRequestImpactLabel -PullRequest $pullRequest

    foreach ($request in New-IssueImpactLabelRequests -Repository $Repository -IssueNumbers $issueNumbers -ImpactLabel $impactLabel) {
        Invoke-GhApiWithJsonBody -Endpoint $request.Endpoint -Method $request.Method -Payload $request.Payload | Out-Null
    }

    $releases = Invoke-GhJson -Arguments @('release', 'list', '--repo', $Repository, '--limit', '100', '--json', 'tagName,isDraft,isPrerelease')
    $previousTag = Get-LatestSemVerReleaseTag -Releases @($releases)
    $nextVersion = Get-NextReleaseVersion -CurrentVersion $previousTag -ImpactLabel $impactLabel
    $releaseNotes = Get-ReleaseNotesFromGitHub `
        -Repository $Repository `
        -Version $nextVersion `
        -TargetCommitish $TargetCommitish `
        -PreviousTag $previousTag `
        -ImpactLabel $impactLabel `
        -IssueNumbers $issueNumbers

    $payload = New-ReleaseCreatePayload -Version $nextVersion -ReleaseNotes $releaseNotes -TargetCommitish $TargetCommitish
    Invoke-GhApiWithJsonBody -Endpoint "repos/$Repository/releases" -Method 'POST' -Payload $payload | Out-Null

    Write-Host "Release $nextVersion published from PR #$PullRequestNumber."
}

if ($MyInvocation.InvocationName -ne '.') {
    if (-not $Mode) {
        throw 'Mode is required.'
    }

    switch ($Mode) {
        'ValidatePullRequest' {
            Invoke-ValidatePullRequestCommand -Repository $Repository -PullRequestNumber $PullRequestNumber
        }
        'PublishMergedPullRequest' {
            Invoke-PublishMergedPullRequestCommand -Repository $Repository -PullRequestNumber $PullRequestNumber -TargetCommitish $TargetCommitish
        }
    }
}

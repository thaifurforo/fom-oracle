param(
    [string]$Version,
    [bool]$Publish = $false,
    [bool]$RegenerateNotes = $true,
    [string]$Repository = 'thaifurforo/fom-oracle',
    [string]$TargetCommitish = 'main',
    [string]$CurrentRef = 'main'
)

$ErrorActionPreference = 'Stop'

function Get-ReleasePolicy {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version
    )

    $policies = @{
        'v0.1.0' = @{
            Milestone = 'v0.1.0 — Fundação do workspace'
            PreviousTag = $null
            Prerelease = $true
            MakeLatest = 'false'
        }
        'v0.2.0' = @{
            Milestone = 'v0.2.0 — Saves e snapshots'
            PreviousTag = 'v0.1.0'
            Prerelease = $true
            MakeLatest = 'false'
        }
        'v0.3.0' = @{
            Milestone = 'v0.3.0 — Painel, prioridades e catálogo local'
            PreviousTag = 'v0.2.0'
            Prerelease = $true
            MakeLatest = 'false'
        }
        'v0.4.0' = @{
            Milestone = 'v0.4.0 — Recomendações estratégicas'
            PreviousTag = 'v0.3.0'
            Prerelease = $true
            MakeLatest = 'false'
        }
        'v0.5.0' = @{
            Milestone = 'v0.5.0 — Resiliência e readiness local-first'
            PreviousTag = 'v0.4.0'
            Prerelease = $true
            MakeLatest = 'false'
        }
        'v1.0.0' = @{
            Milestone = $null
            PreviousTag = 'v0.5.0'
            Prerelease = $false
            MakeLatest = 'true'
            ReadinessIssue = 37
        }
    }

    if (-not $policies.ContainsKey($Version)) {
        throw "Unsupported release version: $Version"
    }

    return $policies[$Version]
}

function Get-V0ReleaseTags {
    return @('v0.1.0', 'v0.2.0', 'v0.3.0', 'v0.4.0', 'v0.5.0')
}

function Get-V0MilestoneTitles {
    return (Get-V0ReleaseTags | ForEach-Object { (Get-ReleasePolicy -Version $_).Milestone })
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

function Find-ReleaseByTag {
    param(
        [object[]]$Releases,
        [string]$Tag
    )

    return @($Releases | Where-Object { (Get-ObjectValue -InputObject $_ -Names @('tagName', 'tag_name')) -eq $Tag } | Select-Object -First 1)[0]
}

function Find-MilestoneByTitle {
    param(
        [object[]]$Milestones,
        [string]$Title
    )

    return @($Milestones | Where-Object { (Get-ObjectValue -InputObject $_ -Names @('title')) -eq $Title } | Select-Object -First 1)[0]
}

function Assert-ReleaseReadiness {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [Parameter(Mandatory = $true)]
        [hashtable]$Policy,
        [Parameter(Mandatory = $true)]
        [object]$Release,
        [object[]]$Milestones = @(),
        [object[]]$Releases = @(),
        [object]$ReadinessIssue,
        [bool]$Publish = $false,
        [string]$CurrentRef = 'main'
    )

    if ($Publish -and $CurrentRef -ne 'main') {
        throw "Publishing releases is only allowed from main. Current ref: $CurrentRef"
    }

    if ($null -eq $Release) {
        throw "Draft release $Version was not found."
    }

    $isDraft = [bool](Get-ObjectValue -InputObject $Release -Names @('isDraft', 'draft'))
    if (-not $isDraft) {
        throw "Release $Version must be a draft before publishing."
    }

    if ($Version -eq 'v1.0.0') {
        foreach ($tag in Get-V0ReleaseTags) {
            $v0Release = Find-ReleaseByTag -Releases $Releases -Tag $tag
            $v0Draft = if ($null -eq $v0Release) { $true } else { [bool](Get-ObjectValue -InputObject $v0Release -Names @('isDraft', 'draft')) }
            if ($null -eq $v0Release -or $v0Draft) {
                throw "Release $tag must be published before v1.0.0."
            }
        }

        foreach ($milestoneTitle in Get-V0MilestoneTitles) {
            $milestone = Find-MilestoneByTitle -Milestones $Milestones -Title $milestoneTitle
            $state = Get-ObjectValue -InputObject $milestone -Names @('state')
            $openIssues = [int](Get-ObjectValue -InputObject $milestone -Names @('open_issues', 'openIssues'))
            if ($null -eq $milestone -or $state -ne 'closed' -or $openIssues -ne 0) {
                throw "Milestone $milestoneTitle must be closed before publishing v1.0.0."
            }
        }

        $readinessState = Get-ObjectValue -InputObject $ReadinessIssue -Names @('state')
        if ($readinessState -ne 'CLOSED') {
            throw 'Readiness issue #37 must be closed before publishing v1.0.0.'
        }

        return
    }

    $milestone = Find-MilestoneByTitle -Milestones $Milestones -Title $Policy.Milestone
    if ($null -eq $milestone) {
        throw "Milestone $($Policy.Milestone) was not found."
    }

    $openIssueCount = [int](Get-ObjectValue -InputObject $milestone -Names @('open_issues', 'openIssues'))
    if ($openIssueCount -gt 0) {
        throw "Milestone $($Policy.Milestone) still has $openIssueCount open issue(s)."
    }
}

function New-ReleaseNotesPayload {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [Parameter(Mandatory = $true)]
        [hashtable]$Policy,
        [Parameter(Mandatory = $true)]
        [string]$TargetCommitish
    )

    $payload = @{
        tag_name = $Version
        target_commitish = $TargetCommitish
        configuration_file_path = '.github/release.yml'
    }

    if ($Policy.PreviousTag) {
        $payload.previous_tag_name = $Policy.PreviousTag
    }

    return $payload
}

function New-ReleaseNotesBody {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [Parameter(Mandatory = $true)]
        [hashtable]$Policy,
        [Parameter(Mandatory = $true)]
        [string]$GeneratedBody
    )

    if ($Version -eq 'v1.0.0') {
        $gate = @(
            '## Release Gate'
            ''
            '- Readiness issue: `#37`'
            '- Validation: v0.1.0 through v0.5.0 published'
            '- Validation: all v0.x.0 milestones closed'
            '- Published from: `main`'
        ) -join "`n"
    } else {
        $gate = @(
            '## Release Gate'
            ''
            ('- Milestone: `' + $Policy.Milestone + '`')
            '- Validation: all milestone issues closed'
            '- Published from: `main`'
        ) -join "`n"
    }

    return "$gate`n`n$GeneratedBody"
}

function New-ReleaseUpdatePayload {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [Parameter(Mandatory = $true)]
        [hashtable]$Policy,
        [Parameter(Mandatory = $true)]
        [object]$Release,
        [Parameter(Mandatory = $true)]
        [string]$ReleaseNotes,
        [Parameter(Mandatory = $true)]
        [string]$TargetCommitish,
        [bool]$Publish = $false
    )

    return @{
        tag_name = $Version
        target_commitish = $TargetCommitish
        name = (Get-ObjectValue -InputObject $Release -Names @('name'))
        body = $ReleaseNotes
        draft = (-not $Publish)
        prerelease = [bool]$Policy.Prerelease
        make_latest = [string]$Policy.MakeLatest
    }
}

function Get-MilestoneToCloseAfterPublish {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [Parameter(Mandatory = $true)]
        [hashtable]$Policy
    )

    if ($Version -eq 'v1.0.0') {
        return $null
    }

    return $Policy.Milestone
}

function Invoke-GhJson {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $output = & gh @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "gh $($Arguments -join ' ') failed."
    }

    if ([string]::IsNullOrWhiteSpace($output)) {
        return $null
    }

    return ($output -join "`n") | ConvertFrom-Json
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

function Get-ReleaseNotesFromGitHub {
    param(
        [string]$Repository,
        [string]$Version,
        [hashtable]$Policy,
        [string]$TargetCommitish
    )

    $payload = New-ReleaseNotesPayload -Version $Version -Policy $Policy -TargetCommitish $TargetCommitish
    $generated = Invoke-GhApiWithJsonBody -Endpoint "repos/$Repository/releases/generate-notes" -Method 'POST' -Payload $payload
    return New-ReleaseNotesBody -Version $Version -Policy $Policy -GeneratedBody $generated.body
}

function Invoke-PublishReleaseCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [bool]$Publish,
        [bool]$RegenerateNotes,
        [string]$Repository,
        [string]$TargetCommitish,
        [string]$CurrentRef
    )

    $policy = Get-ReleasePolicy -Version $Version
    $release = Invoke-GhJson -Arguments @('release', 'view', $Version, '--repo', $Repository, '--json', 'databaseId,tagName,name,body,isDraft,isPrerelease')
    $milestones = Invoke-GhJson -Arguments @('api', "repos/$Repository/milestones?state=all&per_page=100")
    $releases = Invoke-GhJson -Arguments @('release', 'list', '--repo', $Repository, '--limit', '100', '--json', 'tagName,name,isDraft,isPrerelease')
    $readinessIssue = $null

    if ($policy.ReadinessIssue) {
        $readinessIssue = Invoke-GhJson -Arguments @('issue', 'view', ([string]$policy.ReadinessIssue), '--repo', $Repository, '--json', 'number,title,state,url')
    }

    Assert-ReleaseReadiness `
        -Version $Version `
        -Policy $policy `
        -Release $release `
        -Milestones @($milestones) `
        -Releases @($releases) `
        -ReadinessIssue $readinessIssue `
        -Publish:$Publish `
        -CurrentRef $CurrentRef

    $releaseNotes = $release.body
    if ($RegenerateNotes) {
        $releaseNotes = Get-ReleaseNotesFromGitHub -Repository $Repository -Version $Version -Policy $policy -TargetCommitish $TargetCommitish
    }

    $updatePayload = New-ReleaseUpdatePayload `
        -Version $Version `
        -Policy $policy `
        -Release $release `
        -ReleaseNotes $releaseNotes `
        -TargetCommitish $TargetCommitish `
        -Publish:$Publish

    $releaseId = Get-ObjectValue -InputObject $release -Names @('databaseId', 'id')
    Invoke-GhApiWithJsonBody -Endpoint "repos/$Repository/releases/$releaseId" -Method 'PATCH' -Payload $updatePayload | Out-Null

    if (-not $Publish) {
        Write-Host "Release $Version validated. Draft remains unpublished."
        return
    }

    $milestoneToClose = Get-MilestoneToCloseAfterPublish -Version $Version -Policy $policy
    if ($milestoneToClose) {
        $milestone = Find-MilestoneByTitle -Milestones @($milestones) -Title $milestoneToClose
        $milestoneNumber = Get-ObjectValue -InputObject $milestone -Names @('number')
        Invoke-GhApiWithJsonBody -Endpoint "repos/$Repository/milestones/$milestoneNumber" -Method 'PATCH' -Payload @{ state = 'closed' } | Out-Null
    }

    Write-Host "Release $Version published."
}

if ($MyInvocation.InvocationName -ne '.') {
    Invoke-PublishReleaseCommand `
        -Version $Version `
        -Publish:$Publish `
        -RegenerateNotes:$RegenerateNotes `
        -Repository $Repository `
        -TargetCommitish $TargetCommitish `
        -CurrentRef $CurrentRef
}

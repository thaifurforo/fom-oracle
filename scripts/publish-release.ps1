param(
    [string]$Version,
    [bool]$Publish = $false,
    [bool]$RegenerateNotes = $true,
    [string]$Repository = 'thaifurforo/fom-oracle',
    [string]$TargetCommitish = 'main',
    [string]$CurrentRef = 'main'
)

$ErrorActionPreference = 'Stop'

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

function Get-ReleaseKind {
    param(
        [Parameter(Mandatory = $true)]
        [object]$ParsedVersion
    )

    if ($ParsedVersion.Minor -eq 0 -and $ParsedVersion.Patch -eq 0) {
        return 'major'
    }

    if ($ParsedVersion.Patch -eq 0) {
        return 'minor'
    }

    return 'patch'
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

function Find-MilestoneByVersion {
    param(
        [object[]]$Milestones = @(),
        [Parameter(Mandatory = $true)]
        [string]$Version
    )

    $escapedVersion = [regex]::Escape($Version)
    return @(
        $Milestones |
            Where-Object {
                $title = [string](Get-ObjectValue -InputObject $_ -Names @('title'))
                $title -match "^$escapedVersion($|[\s\-—])"
            } |
            Select-Object -First 1
    )[0]
}

function Get-ReleasePolicy {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [object[]]$Milestones = @()
    )

    $parsedVersion = ConvertTo-ReleaseVersion -Version $Version
    $milestone = Find-MilestoneByVersion -Milestones $Milestones -Version $Version
    $milestoneTitle = if ($null -eq $milestone) { $null } else { Get-ObjectValue -InputObject $milestone -Names @('title') }
    $isStable = $parsedVersion.Major -ge 1

    return @{
        Version = $Version
        ParsedVersion = $parsedVersion
        Kind = Get-ReleaseKind -ParsedVersion $parsedVersion
        Milestone = $milestoneTitle
        Prerelease = (-not $isStable)
        MakeLatest = if ($isStable) { 'true' } else { 'false' }
    }
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
        [object]$Release,
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

    return @{
        tag_name = $Version
        target_commitish = $TargetCommitish
        configuration_file_path = '.github/release.yml'
    }
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

    $gateLines = @(
        '## Release Gate'
        ''
        '- Version: `' + $Version + '`'
    )

    if ($Policy.Milestone) {
        $gateLines += ('- Milestone: `' + $Policy.Milestone + '`')
    }

    $gateLines += '- Validation: draft release exists'
    $gateLines += '- Published from: `main`'

    return "$($gateLines -join "`n")`n`n$GeneratedBody"
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

    ConvertTo-ReleaseVersion -Version $Version | Out-Null

    $release = Invoke-GhJson -Arguments @('release', 'view', $Version, '--repo', $Repository, '--json', 'databaseId,tagName,name,body,isDraft,isPrerelease')
    $milestones = Invoke-GhJson -Arguments @('api', "repos/$Repository/milestones?state=all&per_page=100")
    $policy = Get-ReleasePolicy -Version $Version -Milestones @($milestones)

    Assert-ReleaseReadiness `
        -Version $Version `
        -Policy $policy `
        -Release $release `
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

$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot '..\scripts\publish-release.ps1'
. $scriptPath

function New-TestIssue {
    param(
        [Parameter(Mandatory = $true)]
        [int]$Number,
        [Parameter(Mandatory = $true)]
        [string[]]$Labels
    )

    return [pscustomobject]@{
        number = $Number
        title = "Issue $Number"
        labels = @($Labels | ForEach-Object { [pscustomobject]@{ name = $_ } })
    }
}

Describe 'publish-release policy' {
    It 'accepts valid unknown semantic release versions' {
        $policy = Get-ReleasePolicy -Version 'v0.6.0' -Milestones @(
            [pscustomobject]@{ title = 'v0.6.0 - Future work'; open_issues = 0; state = 'open' }
        )

        $policy.Version | Should Be 'v0.6.0'
        $policy.Milestone | Should Be 'v0.6.0 - Future work'
        $policy.Prerelease | Should Be $true
        $policy.MakeLatest | Should Be 'false'
    }

    It 'rejects release versions without the vMAJOR.MINOR.PATCH shape' {
        { Get-ReleasePolicy -Version '0.6.0' -Milestones @() } | Should Throw 'Release version must use vMAJOR.MINOR.PATCH format: 0.6.0'
        { Get-ReleasePolicy -Version 'v0.6' -Milestones @() } | Should Throw 'Release version must use vMAJOR.MINOR.PATCH format: v0.6'
    }

    It 'fails a minor release when a linked patch issue is still open' {
        $policy = Get-ReleasePolicy -Version 'v0.2.0' -Milestones @(
            [pscustomobject]@{ title = 'v0.2.0 - Saves'; open_issues = 0; state = 'open' }
        )
        $release = [pscustomobject]@{ tagName = 'v0.2.0'; isDraft = $true; name = 'v0.2.0 - Saves' }
        $issues = @(New-TestIssue -Number 42 -Labels @('release:v0.2.1'))

        {
            Assert-ReleaseReadiness `
                -Version 'v0.2.0' `
                -Policy $policy `
                -Release $release `
                -OpenIssues $issues `
                -Publish:$false `
                -CurrentRef 'main'
        } | Should Throw 'Release v0.2.0 is blocked by open patch issue(s): #42 release:v0.2.1'
    }

    It 'does not fail a minor release for a patch issue from another minor' {
        $policy = Get-ReleasePolicy -Version 'v0.2.0' -Milestones @(
            [pscustomobject]@{ title = 'v0.2.0 - Saves'; open_issues = 0; state = 'open' }
        )
        $release = [pscustomobject]@{ tagName = 'v0.2.0'; isDraft = $true; name = 'v0.2.0 - Saves' }
        $issues = @(New-TestIssue -Number 43 -Labels @('release:v0.3.1'))

        {
            Assert-ReleaseReadiness `
                -Version 'v0.2.0' `
                -Policy $policy `
                -Release $release `
                -OpenIssues $issues `
                -Publish:$false `
                -CurrentRef 'main'
        } | Should Not Throw
    }

    It 'fails v1.0.0 when a lower minor issue is still open' {
        $policy = Get-ReleasePolicy -Version 'v1.0.0' -Milestones @(
            [pscustomobject]@{ title = 'v1.0.0 - Local-first MVP'; open_issues = 0; state = 'open' }
        )
        $release = [pscustomobject]@{ tagName = 'v1.0.0'; isDraft = $true; name = 'v1.0.0 - Local-first MVP' }
        $issues = @(New-TestIssue -Number 44 -Labels @('release:v0.5.0'))

        {
            Assert-ReleaseReadiness `
                -Version 'v1.0.0' `
                -Policy $policy `
                -Release $release `
                -OpenIssues $issues `
                -Publish:$false `
                -CurrentRef 'main'
        } | Should Throw 'Release v1.0.0 is blocked by open lower minor issue(s): #44 release:v0.5.0'
    }

    It 'fails v2.0.0 when a lower minor issue from v1 is still open' {
        $policy = Get-ReleasePolicy -Version 'v2.0.0' -Milestones @(
            [pscustomobject]@{ title = 'v2.0.0 - Stable'; open_issues = 0; state = 'open' }
        )
        $release = [pscustomobject]@{ tagName = 'v2.0.0'; isDraft = $true; name = 'v2.0.0 - Stable' }
        $issues = @(New-TestIssue -Number 45 -Labels @('release:v1.3.0'))

        {
            Assert-ReleaseReadiness `
                -Version 'v2.0.0' `
                -Policy $policy `
                -Release $release `
                -OpenIssues $issues `
                -Publish:$false `
                -CurrentRef 'main'
        } | Should Throw 'Release v2.0.0 is blocked by open lower minor issue(s): #45 release:v1.3.0'
    }

    It 'does not require readiness issue 37 for v1.0.0' {
        $policy = Get-ReleasePolicy -Version 'v1.0.0' -Milestones @(
            [pscustomobject]@{ title = 'v1.0.0 - Local-first MVP'; open_issues = 0; state = 'open' }
        )
        $release = [pscustomobject]@{ tagName = 'v1.0.0'; isDraft = $true; name = 'v1.0.0 - Local-first MVP' }

        {
            Assert-ReleaseReadiness `
                -Version 'v1.0.0' `
                -Policy $policy `
                -Release $release `
                -OpenIssues @() `
                -Publish:$false `
                -CurrentRef 'main'
        } | Should Not Throw
    }

    It 'keeps using the GitHub release notes configuration file' {
        $policy = Get-ReleasePolicy -Version 'v0.6.1' -Milestones @()

        $payload = New-ReleaseNotesPayload -Version 'v0.6.1' -Policy $policy -TargetCommitish 'main'

        $payload.tag_name | Should Be 'v0.6.1'
        $payload.target_commitish | Should Be 'main'
        $payload.configuration_file_path | Should Be '.github/release.yml'
    }

    It 'builds v0 release payloads as prerelease and not latest' {
        $policy = Get-ReleasePolicy -Version 'v0.6.0' -Milestones @(
            [pscustomobject]@{ title = 'v0.6.0 - Future work'; open_issues = 0; state = 'open' }
        )
        $release = [pscustomobject]@{ name = 'v0.6.0 - Future work' }

        $payload = New-ReleaseUpdatePayload -Version 'v0.6.0' -Policy $policy -Release $release -ReleaseNotes 'notes' -TargetCommitish 'main' -Publish:$true

        $payload.draft | Should Be $false
        $payload.prerelease | Should Be $true
        $payload.make_latest | Should Be 'false'
    }

    It 'builds v1.0.0 and later payloads as stable and latest' {
        $v1Policy = Get-ReleasePolicy -Version 'v1.0.0' -Milestones @(
            [pscustomobject]@{ title = 'v1.0.0 - Stable'; open_issues = 0; state = 'open' }
        )
        $v2Policy = Get-ReleasePolicy -Version 'v2.0.0' -Milestones @(
            [pscustomobject]@{ title = 'v2.0.0 - Stable'; open_issues = 0; state = 'open' }
        )
        $release = [pscustomobject]@{ name = 'stable' }

        $v1Payload = New-ReleaseUpdatePayload -Version 'v1.0.0' -Policy $v1Policy -Release $release -ReleaseNotes 'notes' -TargetCommitish 'main' -Publish:$true
        $v2Payload = New-ReleaseUpdatePayload -Version 'v2.0.0' -Policy $v2Policy -Release $release -ReleaseNotes 'notes' -TargetCommitish 'main' -Publish:$true

        $v1Payload.prerelease | Should Be $false
        $v1Payload.make_latest | Should Be 'true'
        $v2Payload.prerelease | Should Be $false
        $v2Payload.make_latest | Should Be 'true'
    }

    It 'closes the matching milestone after a successful publish when one exists' {
        $policy = Get-ReleasePolicy -Version 'v0.6.0' -Milestones @(
            [pscustomobject]@{ title = 'v0.6.0 - Future work'; open_issues = 0; state = 'open' }
        )
        $patchPolicy = Get-ReleasePolicy -Version 'v0.6.1' -Milestones @()

        Get-MilestoneToCloseAfterPublish -Version 'v0.6.0' -Policy $policy | Should Be 'v0.6.0 - Future work'
        Get-MilestoneToCloseAfterPublish -Version 'v0.6.1' -Policy $patchPolicy | Should Be $null
    }

    It 'rejects publish mode from a non-main ref' {
        $policy = Get-ReleasePolicy -Version 'v0.6.1' -Milestones @()
        $release = [pscustomobject]@{ tagName = 'v0.6.1'; isDraft = $true; name = 'v0.6.1' }

        {
            Assert-ReleaseReadiness `
                -Version 'v0.6.1' `
                -Policy $policy `
                -Release $release `
                -OpenIssues @() `
                -Publish:$true `
                -CurrentRef 'feature/test'
        } | Should Throw 'Publishing releases is only allowed from main. Current ref: feature/test'
    }

    It 'uses TEMP for JSON payload files when RUNNER_TEMP is not available' {
        $previousRunnerTemp = $env:RUNNER_TEMP
        $env:RUNNER_TEMP = ''
        $tempPayloadPath = $null

        try {
            $tempPayloadPath = New-JsonTempFile -Payload @{ state = 'closed' }

            Test-Path -LiteralPath $tempPayloadPath | Should Be $true
            $tempPayloadPath.StartsWith($env:TEMP) | Should Be $true
        } finally {
            if ($tempPayloadPath -and
                $tempPayloadPath.StartsWith($env:TEMP) -and
                (Split-Path -Leaf $tempPayloadPath).StartsWith('release-payload-') -and
                (Test-Path -LiteralPath $tempPayloadPath)) {
                Remove-Item -LiteralPath $tempPayloadPath -Force
            }
            $env:RUNNER_TEMP = $previousRunnerTemp
        }
    }
}

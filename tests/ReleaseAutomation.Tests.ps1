$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot '..\scripts\release-automation.ps1'
. $scriptPath

function New-TestLabel {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    return [pscustomobject]@{ name = $Name }
}

function New-TestPullRequest {
    param(
        [string]$Body = '',
        [string[]]$Labels = @()
    )

    return [pscustomobject]@{
        body = $Body
        labels = @($Labels | ForEach-Object { New-TestLabel -Name $_ })
    }
}

Describe 'PR release automation' {
    It 'fails a PR without closing keywords' {
        $pullRequest = New-TestPullRequest -Body 'Implements the workspace setup.' -Labels @('release:patch')

        { Assert-ReleasePullRequest -PullRequest $pullRequest -ExistingIssueNumbers @() } |
            Should Throw 'Pull request body must include a closing keyword for at least one issue.'
    }

    It 'fails a PR with a closing keyword but no release impact label' {
        $pullRequest = New-TestPullRequest -Body 'Closes #12' -Labels @('infra')

        { Assert-ReleasePullRequest -PullRequest $pullRequest -ExistingIssueNumbers @(12) } |
            Should Throw 'Pull request must have exactly one release impact label: release:patch, release:minor, or release:major.'
    }

    It 'fails a PR with more than one release impact label' {
        $pullRequest = New-TestPullRequest -Body 'Fixes #12' -Labels @('release:patch', 'release:minor')

        { Assert-ReleasePullRequest -PullRequest $pullRequest -ExistingIssueNumbers @(12) } |
            Should Throw 'Pull request must have exactly one release impact label: release:patch, release:minor, or release:major.'
    }

    It 'fails when a referenced issue does not exist in the repository' {
        $pullRequest = New-TestPullRequest -Body 'Resolves #12 and closes #13' -Labels @('release:patch')

        { Assert-ReleasePullRequest -PullRequest $pullRequest -ExistingIssueNumbers @(12) } |
            Should Throw 'Pull request references issue(s) not found in this repository: #13'
    }

    It 'passes with one release impact label and existing closing issue references' {
        $pullRequest = New-TestPullRequest -Body "Closes #12`nFixes #13" -Labels @('release:patch')

        {
            Assert-ReleasePullRequest -PullRequest $pullRequest -ExistingIssueNumbers @(12, 13)
        } | Should Not Throw
    }

    It 'extracts unique issue numbers from supported closing keywords' {
        $body = @'
Closes #12
fixes #13
Resolved #12
close thaifurforo/fom-oracle#14
'@

        Get-ClosingIssueNumbers -Body $body | Should Be @(12, 13, 14)
    }

    It 'calculates patch, minor, and major versions with SemVer resets' {
        Get-NextReleaseVersion -CurrentVersion 'v1.0.3' -ImpactLabel 'release:patch' | Should Be 'v1.0.4'
        Get-NextReleaseVersion -CurrentVersion 'v1.0.3' -ImpactLabel 'release:minor' | Should Be 'v1.1.0'
        Get-NextReleaseVersion -CurrentVersion 'v1.2.4' -ImpactLabel 'release:major' | Should Be 'v2.0.0'
    }

    It 'uses v0.0.0 as the base version when there are no published releases' {
        Get-LatestSemVerReleaseTag -Releases @() | Should Be 'v0.0.0'
        Get-NextReleaseVersion -CurrentVersion 'v0.0.0' -ImpactLabel 'release:patch' | Should Be 'v0.0.1'
    }

    It 'selects the highest semantic version release tag' {
        $releases = @(
            [pscustomobject]@{ tagName = 'v1.0.3'; isDraft = $false },
            [pscustomobject]@{ tagName = 'notes-only'; isDraft = $false },
            [pscustomobject]@{ tagName = 'v1.2.0'; isDraft = $false },
            [pscustomobject]@{ tagName = 'v2.0.0'; isDraft = $true }
        )

        Get-LatestSemVerReleaseTag -Releases $releases | Should Be 'v1.2.0'
    }

    It 'builds issue label sync endpoints for all closed issues' {
        $commands = New-IssueImpactLabelRequests -Repository 'owner/repo' -IssueNumbers @(12, 13) -ImpactLabel 'release:minor'

        $commands.Count | Should Be 2
        $commands[0].Endpoint | Should Be 'repos/owner/repo/issues/12/labels'
        $commands[0].Payload.labels | Should Be @('release:minor')
        $commands[1].Endpoint | Should Be 'repos/owner/repo/issues/13/labels'
    }
}

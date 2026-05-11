$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot '..\scripts\publish-release.ps1'
. $scriptPath

Describe 'publish-release policy' {
    It 'maps v0.1.0 to the workspace foundation milestone and prerelease settings' {
        $policy = Get-ReleasePolicy -Version 'v0.1.0'

        $policy.Milestone | Should Be 'v0.1.0 — Fundação do workspace'
        $policy.PreviousTag | Should Be $null
        $policy.Prerelease | Should Be $true
        $policy.MakeLatest | Should Be 'false'
    }

    It 'rejects unknown release versions with a clear error' {
        { Get-ReleasePolicy -Version 'v9.9.9' } | Should Throw 'Unsupported release version: v9.9.9'
    }

    It 'fails a v0 release when the mapped milestone still has open issues' {
        $policy = Get-ReleasePolicy -Version 'v0.1.0'
        $release = [pscustomobject]@{ tagName = 'v0.1.0'; isDraft = $true; name = 'v0.1.0 — Fundação do workspace' }
        $milestones = @([pscustomobject]@{ title = $policy.Milestone; open_issues = 2; state = 'open' })

        {
            Assert-ReleaseReadiness `
                -Version 'v0.1.0' `
                -Policy $policy `
                -Release $release `
                -Milestones $milestones `
                -Releases @() `
                -ReadinessIssue $null `
                -Publish:$false `
                -CurrentRef 'main'
        } | Should Throw 'Milestone v0.1.0 — Fundação do workspace still has 2 open issue(s).'
    }

    It 'passes a v0 release when the release is draft and the mapped milestone has no open issues' {
        $policy = Get-ReleasePolicy -Version 'v0.1.0'
        $release = [pscustomobject]@{ tagName = 'v0.1.0'; isDraft = $true; name = 'v0.1.0 — Fundação do workspace' }
        $milestones = @([pscustomobject]@{ title = $policy.Milestone; open_issues = 0; state = 'open' })

        {
            Assert-ReleaseReadiness `
                -Version 'v0.1.0' `
                -Policy $policy `
                -Release $release `
                -Milestones $milestones `
                -Releases @() `
                -ReadinessIssue $null `
                -Publish:$false `
                -CurrentRef 'main'
        } | Should Not Throw
    }

    It 'fails v1.0.0 while readiness issue 37 is open' {
        $policy = Get-ReleasePolicy -Version 'v1.0.0'
        $release = [pscustomobject]@{ tagName = 'v1.0.0'; isDraft = $true; name = 'v1.0.0 — Local-first MVP' }
        $publishedV0 = @(
            [pscustomobject]@{ tagName = 'v0.1.0'; isDraft = $false; isPrerelease = $true },
            [pscustomobject]@{ tagName = 'v0.2.0'; isDraft = $false; isPrerelease = $true },
            [pscustomobject]@{ tagName = 'v0.3.0'; isDraft = $false; isPrerelease = $true },
            [pscustomobject]@{ tagName = 'v0.4.0'; isDraft = $false; isPrerelease = $true },
            [pscustomobject]@{ tagName = 'v0.5.0'; isDraft = $false; isPrerelease = $true }
        )
        $closedMilestones = @(
            [pscustomobject]@{ title = 'v0.1.0 — Fundação do workspace'; state = 'closed'; open_issues = 0 },
            [pscustomobject]@{ title = 'v0.2.0 — Saves e snapshots'; state = 'closed'; open_issues = 0 },
            [pscustomobject]@{ title = 'v0.3.0 — Painel, prioridades e catálogo local'; state = 'closed'; open_issues = 0 },
            [pscustomobject]@{ title = 'v0.4.0 — Recomendações estratégicas'; state = 'closed'; open_issues = 0 },
            [pscustomobject]@{ title = 'v0.5.0 — Resiliência e readiness local-first'; state = 'closed'; open_issues = 0 }
        )
        $readinessIssue = [pscustomobject]@{ number = 37; state = 'OPEN' }

        {
            Assert-ReleaseReadiness `
                -Version 'v1.0.0' `
                -Policy $policy `
                -Release $release `
                -Milestones $closedMilestones `
                -Releases $publishedV0 `
                -ReadinessIssue $readinessIssue `
                -Publish:$false `
                -CurrentRef 'main'
        } | Should Throw 'Readiness issue #37 must be closed before publishing v1.0.0.'
    }

    It 'passes v1.0.0 when v0 releases are published, v0 milestones are closed, and issue 37 is closed' {
        $policy = Get-ReleasePolicy -Version 'v1.0.0'
        $release = [pscustomobject]@{ tagName = 'v1.0.0'; isDraft = $true; name = 'v1.0.0 — Local-first MVP' }
        $publishedV0 = @(
            [pscustomobject]@{ tagName = 'v0.1.0'; isDraft = $false; isPrerelease = $true },
            [pscustomobject]@{ tagName = 'v0.2.0'; isDraft = $false; isPrerelease = $true },
            [pscustomobject]@{ tagName = 'v0.3.0'; isDraft = $false; isPrerelease = $true },
            [pscustomobject]@{ tagName = 'v0.4.0'; isDraft = $false; isPrerelease = $true },
            [pscustomobject]@{ tagName = 'v0.5.0'; isDraft = $false; isPrerelease = $true }
        )
        $closedMilestones = @(
            [pscustomobject]@{ title = 'v0.1.0 — Fundação do workspace'; state = 'closed'; open_issues = 0 },
            [pscustomobject]@{ title = 'v0.2.0 — Saves e snapshots'; state = 'closed'; open_issues = 0 },
            [pscustomobject]@{ title = 'v0.3.0 — Painel, prioridades e catálogo local'; state = 'closed'; open_issues = 0 },
            [pscustomobject]@{ title = 'v0.4.0 — Recomendações estratégicas'; state = 'closed'; open_issues = 0 },
            [pscustomobject]@{ title = 'v0.5.0 — Resiliência e readiness local-first'; state = 'closed'; open_issues = 0 }
        )
        $readinessIssue = [pscustomobject]@{ number = 37; state = 'CLOSED' }

        {
            Assert-ReleaseReadiness `
                -Version 'v1.0.0' `
                -Policy $policy `
                -Release $release `
                -Milestones $closedMilestones `
                -Releases $publishedV0 `
                -ReadinessIssue $readinessIssue `
                -Publish:$false `
                -CurrentRef 'main'
        } | Should Not Throw
    }

    It 'omits previous_tag_name from generated notes payload for v0.1.0' {
        $policy = Get-ReleasePolicy -Version 'v0.1.0'

        $payload = New-ReleaseNotesPayload -Version 'v0.1.0' -Policy $policy -TargetCommitish 'main'

        $payload.tag_name | Should Be 'v0.1.0'
        $payload.target_commitish | Should Be 'main'
        $payload.configuration_file_path | Should Be '.github/release.yml'
        $payload.ContainsKey('previous_tag_name') | Should Be $false
    }

    It 'sets previous_tag_name for generated notes payload after v0.1.0' {
        $policy = Get-ReleasePolicy -Version 'v0.2.0'

        $payload = New-ReleaseNotesPayload -Version 'v0.2.0' -Policy $policy -TargetCommitish 'main'

        $payload.previous_tag_name | Should Be 'v0.1.0'
    }

    It 'prepends the release gate section to generated notes' {
        $policy = Get-ReleasePolicy -Version 'v0.2.0'

        $notes = New-ReleaseNotesBody -Version 'v0.2.0' -Policy $policy -GeneratedBody "## What's Changed`n- Example"

        $notes | Should Match '## Release Gate'
        $notes | Should Match 'Milestone: `v0.2.0 — Saves e snapshots`'
        $notes | Should Match "## What's Changed"
    }

    It 'rejects publish mode from a non-main ref' {
        $policy = Get-ReleasePolicy -Version 'v0.1.0'
        $release = [pscustomobject]@{ tagName = 'v0.1.0'; isDraft = $true; name = 'v0.1.0 — Fundação do workspace' }
        $milestones = @([pscustomobject]@{ title = $policy.Milestone; open_issues = 0; state = 'open' })

        {
            Assert-ReleaseReadiness `
                -Version 'v0.1.0' `
                -Policy $policy `
                -Release $release `
                -Milestones $milestones `
                -Releases @() `
                -ReadinessIssue $null `
                -Publish:$true `
                -CurrentRef 'feature/test'
        } | Should Throw 'Publishing releases is only allowed from main. Current ref: feature/test'
    }

    It 'builds the v0.3.0 publish payload as prerelease and not latest' {
        $policy = Get-ReleasePolicy -Version 'v0.3.0'
        $release = [pscustomobject]@{ name = 'v0.3.0 — Painel, prioridades e catálogo local' }

        $payload = New-ReleaseUpdatePayload -Version 'v0.3.0' -Policy $policy -Release $release -ReleaseNotes 'notes' -TargetCommitish 'main' -Publish:$true

        $payload.draft | Should Be $false
        $payload.prerelease | Should Be $true
        $payload.make_latest | Should Be 'false'
    }

    It 'builds the v1.0.0 publish payload as stable and latest' {
        $policy = Get-ReleasePolicy -Version 'v1.0.0'
        $release = [pscustomobject]@{ name = 'v1.0.0 — Local-first MVP' }

        $payload = New-ReleaseUpdatePayload -Version 'v1.0.0' -Policy $policy -Release $release -ReleaseNotes 'notes' -TargetCommitish 'main' -Publish:$true

        $payload.draft | Should Be $false
        $payload.prerelease | Should Be $false
        $payload.make_latest | Should Be 'true'
    }

    It 'closes only v0 milestones after a successful publish' {
        $v0Policy = Get-ReleasePolicy -Version 'v0.4.0'
        $v1Policy = Get-ReleasePolicy -Version 'v1.0.0'

        Get-MilestoneToCloseAfterPublish -Version 'v0.4.0' -Policy $v0Policy | Should Be 'v0.4.0 — Recomendações estratégicas'
        Get-MilestoneToCloseAfterPublish -Version 'v1.0.0' -Policy $v1Policy | Should Be $null
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

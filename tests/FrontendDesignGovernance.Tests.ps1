$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot '..\scripts\validate-frontend-design-governance.ps1'
. $scriptPath

function New-TestRepository {
    $testRoot = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path (Join-Path $testRoot 'frontend/src/features/home') -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $testRoot 'frontend/src/features/home/Home.tsx') -Value 'export function Home() { return <main /> }'
    return $testRoot
}

Describe 'Frontend DESIGN.md governance' {
    BeforeEach {
        $script:testRoot = New-TestRepository
        $script:validBody = @'
## Aderência ao DESIGN.md

- [x] Li e apliquei o `DESIGN.md` nas decisões de UI/UX e arquitetura de interface desta PR.

## Evidência visual

Sem impacto visual runtime; mudança validada por inspeção.
'@
    }

    AfterEach {
        Remove-Item -LiteralPath $script:testRoot -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'does not require PR body sections for non-frontend changes' {
        {
            Assert-FrontendDesignGovernance `
                -PullRequestBody '' `
                -ChangedFiles @('backend/src/FomOracle.Service/Recommendations.cs') `
                -RepositoryRoot $script:testRoot
        } | Should Not Throw
    }

    It 'fails frontend PRs without the DESIGN.md adherence section' {
        $body = @'
## Evidência visual

Print anexado.
'@

        {
            Assert-FrontendDesignGovernance `
                -PullRequestBody $body `
                -ChangedFiles @('frontend/src/features/home/Home.tsx') `
                -RepositoryRoot $script:testRoot
        } | Should Throw 'Falta seção obrigatória de aderência ao DESIGN.md.'
    }

    It 'fails frontend PRs without visual evidence section' {
        $body = @'
## Aderência ao DESIGN.md

- [x] Li e apliquei o `DESIGN.md` nas decisões de UI/UX e arquitetura de interface desta PR.
'@

        {
            Assert-FrontendDesignGovernance `
                -PullRequestBody $body `
                -ChangedFiles @('frontend/src/features/home/Home.tsx') `
                -RepositoryRoot $script:testRoot
        } | Should Throw 'Falta seção obrigatória de evidência visual para mudança de frontend/UI.'
    }

    It 'fails frontend PRs when the DESIGN.md checklist is not checked' {
        $body = @'
## Aderência ao DESIGN.md

- [ ] Li e apliquei o `DESIGN.md` nas decisões de UI/UX e arquitetura de interface desta PR.

## Evidência visual

Print anexado.
'@

        {
            Assert-FrontendDesignGovernance `
                -PullRequestBody $body `
                -ChangedFiles @('frontend/src/features/home/Home.tsx') `
                -RepositoryRoot $script:testRoot
        } | Should Throw 'Checklist de aderência ao DESIGN.md não marcado.'
    }

    It 'requires Impacto no DESIGN.md section when the design guide changes' {
        {
            Assert-FrontendDesignGovernance `
                -PullRequestBody $script:validBody `
                -ChangedFiles @('DESIGN.md') `
                -RepositoryRoot $script:testRoot
        } | Should Throw 'Mudanças no DESIGN.md devem preencher a seção Impacto no DESIGN.md.'
    }

    It 'fails when frontend imports concept art or prototypes' {
        Set-Content -LiteralPath (Join-Path $script:testRoot 'frontend/src/features/home/Home.tsx') -Value @'
import concept from "../../../.catalog/assets/concept-art/concept-home.png";
export function Home() { return <img src={concept} /> }
'@

        {
            Assert-FrontendDesignGovernance `
                -PullRequestBody $script:validBody `
                -ChangedFiles @('frontend/src/features/home/Home.tsx') `
                -RepositoryRoot $script:testRoot
        } | Should Throw 'Frontend não pode importar concept art ou protótipos HTML como asset de runtime/UI/bundle. Arquivo: frontend/src/features/home/Home.tsx'
    }

    It 'fails when frontend accesses filesystem directly' {
        Set-Content -LiteralPath (Join-Path $script:testRoot 'frontend/src/features/home/Home.tsx') -Value @'
import { readTextFile } from "@tauri-apps/plugin-fs";
export async function load() { return readTextFile("save.dat"); }
'@

        {
            Assert-FrontendDesignGovernance `
                -PullRequestBody $script:validBody `
                -ChangedFiles @('frontend/src/features/home/Home.tsx') `
                -RepositoryRoot $script:testRoot
        } | Should Throw 'Frontend não pode acessar filesystem diretamente; use a Local API do sidecar. Arquivo: frontend/src/features/home/Home.tsx'
    }

    It 'fails when frontend references SQLite directly' {
        Set-Content -LiteralPath (Join-Path $script:testRoot 'frontend/src/features/home/Home.tsx') -Value @'
import sqlite from "better-sqlite3";
export const db = sqlite("local.db");
'@

        {
            Assert-FrontendDesignGovernance `
                -PullRequestBody $script:validBody `
                -ChangedFiles @('frontend/src/features/home/Home.tsx') `
                -RepositoryRoot $script:testRoot
        } | Should Throw 'Frontend não pode acessar SQLite diretamente; persistência local pertence ao core. Arquivo: frontend/src/features/home/Home.tsx'
    }

    It 'passes when frontend PR has DESIGN.md sections and no forbidden runtime references' {
        {
            Assert-FrontendDesignGovernance `
                -PullRequestBody $script:validBody `
                -ChangedFiles @('frontend/src/features/home/Home.tsx') `
                -RepositoryRoot $script:testRoot
        } | Should Not Throw
    }
}

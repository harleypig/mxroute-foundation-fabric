# mxroute-foundation-fabric Conventions

Repo-specific conventions. The global agent config (`~/.claude/CLAUDE.md` and
`~/.claude/rules/*`) carries everything generic — git/gh workflow, code style,
the QA *dimensions*, Terraform conventions. This file records only what is
specific to **this** repo and overrides the global config where they differ.

mxroute-foundation-fabric is a **generic, reusable** Terraform module library
(Cloud Foundation Fabric-style) for MXroute email hosting, built on the
[`terraform-provider-mxroute`](https://github.com/harleypig/terraform-provider-mxroute)
provider. It holds **no account-specific configuration** — that lives in the
consuming root config (harleydev). The standing bias is a clean, validated,
tested module per provider resource.

## Relationship to the other repos

Three separate repos, each with a distinct job (see the `terraform-provider-patterns`
skill):

- **`terraform-provider-mxroute`** — the provider (its own repo, a Registry
  requirement). Source of truth for each resource's schema.
- **`mxroute-foundation-fabric`** (this repo) — reusable modules wrapping those
  resources. Consumed by git ref (`?ref=vX.Y.Z`).
- **harleydev** — the live account / acceptance-test environment that consumes
  the fabric.

## Module layout

One module per provider resource, directory named after the resource:

```text
modules/<resource>/
  main.tf         # the single resource, for_each over the input map
  variables.tf    # inputs + validation blocks (become the test failure cases)
  outputs.tf      # computed results exposed as maps keyed by the input key
  provider.tf     # required_version + required_providers (mxroute) — self-contained
  README.md       # terraform-docs-generated tables + hand-written prose
  tests/*.tftest.hcl  # plan-only native tests
```

**Factory interface.** Each module takes a `map(object({...}))` input and
`for_each`es the resource over it (mirroring harleydev's `tfmods/`), so one
module instance manages many resources. Outputs are maps keyed by the same
input key.

**Every module carries its own `provider.tf`** (a copy of the
`required_providers` block: `required_version = ">= 1.11"` plus the pinned
`mxroute` provider), so a module stays self-contained when sourced by ref.

## The provider is the source of truth

A module wraps exactly one `mxroute_*` resource. Its inputs mirror that
resource's **settable** attributes (Required/Optional); its outputs expose the
**computed** ones. When the provider adds or changes a resource attribute, the
wrapping module is updated in the same spirit — never fork the resource shape.
Input `validation` blocks should mirror the provider's own validators so a bad
value fails fast at plan time (and becomes an `expect_failures` test case).

## Toolchain — real Terraform (not Docker)

Unlike harleydev (which runs Terraform through Docker), this repo uses a
**locally installed `terraform`**, so `terraform init` resolves the provider
straight from the Registry.

- **Provider availability (local dev):** the `harleypig/mxroute` provider is
  **published to the Terraform Registry**, so `terraform init` installs it from
  the pinned version constraint in each module's `provider.tf` — no build, no
  override. (Before publication, local dev used a `dev.tfrc` dev-override
  against a locally built binary; that was dropped once the provider shipped.)
- **Provider availability (CI):** CI runs `terraform init` per module, pulling
  the provider from the Registry the same way — no Go build, no release-binary
  mirror.
- **terraform-docs** generates each module's README tables via `bin/build-docs`
  (config: `.terraform-docs.yml`, injected between the `BEGIN_TF_DOCS`/
  `END_TF_DOCS` markers). `bin/build-docs` is the single code path for both the
  regenerate hook and the `terraform-docs-check` gate (`bin/build-docs --check`),
  so they cannot drift — it passes `-c .terraform-docs.yml` explicitly, unlike
  the stock `terraform_docs` hook. A module keeps hand-written prose around the
  generated block.

## Versioning & tagging

The library versions as **one unit** — a single semver `vMAJOR.MINOR.PATCH`
covers all modules (matching the provider/`git.md` policy). It is now **stable
at `v1.x`**: the `0 → 1` jump was made at `v1.0.0`, when the library adopted the
stable `harleypig/mxroute` provider v1.0.0. From here a breaking
module-interface change requires a **major** bump, a backward-compatible
feature a **minor**, and a fix a **patch** (the loose `v0.y.z` alpha phase,
where breakage was expected, is over). Tags are **annotated**, cut at the merge
commit on `master` (the **release-tag** skill). A consumer pins a module by
`?ref=vX.Y.Z`.

## Merge policy

`master` is PR-only. Branch first; never commit on `master`. The local
`no-commit-to-branch` hook plus a server-side ruleset enforce it. Required
checks are the CI jobs below.

## Quality assurance

Mapped to the global `qa.md` dimensions. **Status:** Active · Planned · Off ·
N/A. For the Terraform stack, qa-check composes **terraform-review**.

| # | Dimension | Status | Notes |
|---|-----------|--------|-------|
| 1 | Format | **Active** | `terraform fmt` (gated: pre-commit + CI). |
| 2 | Lint | **Active** | `tflint --recursive` (bundled terraform ruleset, recommended preset, `.tflint.hcl`; no `--init`/`--deep`, credential-free) gated in pre-commit + CI. |
| 3 | Type-check | **N/A** | HCL. |
| 4 | Code smell | **Off** | `arch-review` ad hoc. |
| 5 | Security | **Active** | `trivy config` (terraform misconfig scanner) gated in pre-commit + CI. Secrets: `gitleaks` + `detect-private-key` Active. (trivy has no MXroute-specific policies today, so it is a forward guard; it catches generic HCL misconfig.) |
| 6 | Tests | **Active** | Plan-only `.tftest.hcl` per module (`mock_provider`, credential-free). See `TESTS.md`. |
| 7 | UI/UX | **N/A** | No UI. |
| 8 | End-to-end | **N/A** | The consuming root config (harleydev) owns real-infra testing. |
| 9 | Compatibility | **N/A** | Single provider. |
| 10 | Performance | **N/A** | Config repo. |
| 11 | Reliability | **N/A** | No runtime. |
| 12 | Build | **Active** | `terraform validate` per module (CI, after `terraform init` from the Registry). |
| 13 | Documentation | **Active** | terraform-docs READMEs generated by `bin/build-docs`, gated by `terraform-docs-check` (`bin/build-docs --check`) in pre-commit + CI. |
| 14 | Code review | **Active** (informal) | PR required; solo self-merge. `/code-review` on diffs. |
| 15 | CI | **Active** | GitHub Actions; required checks below. |

---
name: adopt-provider-version
description: Adopt a new terraform-provider-mxroute release into this fabric's modules — diff the sibling provider repo between the old and new tag, classify each change (schema-affecting vs correctness-fix vs doc-only) from its CHANGELOG, selectively bump only the module provider.tf pins whose interface or correctness needs it, mirror provider doc/validator changes into module variables/outputs (the provider is the source of truth), regenerate READMEs via bin/build-docs, then terraform init -upgrade + plan-only tests. Use when the user says "adopt provider vX.Y.Z", "bump the provider", "pull in the new provider release", "the provider shipped a new version", or when a provider release needs to land in the fabric. Repo-local to mxroute-foundation-fabric.
---

# Adopt provider version

**Version:** v1.0.0

The provider→fabric adoption procedure, reconstructed by hand three times
(PRs #9, #11, #12) before this skill existed. Each adoption re-derives the same
multi-step sequence: diff the provider, classify the changes, bump only the
pins that need it, mirror the doc/validator changes, regenerate docs, and
re-test against the *new* provider. This skill is that sequence, written
once.

The governing principle is the repo's own: **the provider is the source of
truth** (`.claude/CONVENTIONS.md`). A module wraps exactly one `mxroute_*`
resource; its inputs mirror that resource's settable attributes and its
outputs the computed ones. Adoption is the act of re-synchronizing the
wrapping modules with a new provider release — never forking the resource
shape.

## When to use

- The user wants to pull a new `harleypig/mxroute` provider release into the
  fabric: "adopt provider v0.5.0", "bump the provider", "the provider shipped
  a release".
- A provider change (a new validator, a corrected doc, a read/decode fix)
  needs to reach the modules that wrap the affected resources.

**Skip** when nothing in the fabric consumes the changed resource, or when
the change is purely internal to the provider (no schema, doc, or correctness
effect a consumer can observe).

## Prerequisites

- The **sibling provider repo** is checked out at
  `../terraform-provider-mxroute` (siblings of this clone — see
  `rules/git.md` *Related/Foreign Repositories*). If absent, ask before
  cloning.
- The target release is **published to the Terraform Registry** (this repo
  installs the provider from the Registry, not a local build — see
  `.claude/CONVENTIONS.md` *Toolchain*). Confirm the tag exists upstream.
- A clean working tree on a **working branch** (never `master`).

## The special case: the 0 → 1 stability jump

When the release being adopted is the provider's **v1.0.0** (the alpha→stable
jump), this skill's *selective* per-module pinning is **retired** in favor of
a **uniform** floor: bump every module's `provider.tf` pin to `>= 1.0.0` at
once. See the `TODO.md` *Provider adoption* item. A v1.0.0 is also likely to
carry **breaking** resource changes (e.g. an attribute becoming read-only) —
treat those per *Classify each change* below, and note that once the provider
is v1+, a breaking module-interface change requires a **major** fabric bump
(`.claude/CONVENTIONS.md` *Versioning & tagging*). For a normal `v0.y.z` →
`v0.(y+1).z` alpha adoption, follow the selective procedure.

## Procedure

### 1. Establish old → new

Determine the version currently adopted and the target:

```sh
# Current per-module pins (the selective scheme — pins differ by module):
grep -H 'version = ' modules/*/provider.tf

# The target: the new tag upstream.
git -C ../terraform-provider-mxroute tag --sort=-v:refname | head
```

The "old" baseline for the diff is the **highest** version any module
currently pins that the release supersedes; a per-module pin may lag (a
module untouched since `>= 0.1.0` is still on the original floor).

### 2. Diff the provider and classify each change

Read the release's **CHANGELOG** section first — it is authored to classify
changes (BREAKING / ENHANCEMENTS / BUG FIXES / NOTES):

```sh
sed -n '/^## <new-version>/,/^## /p' ../terraform-provider-mxroute/CHANGELOG.md
git -C ../terraform-provider-mxroute diff v<old>..v<new> -- internal/ docs/
```

Sort every change into one bucket — the bucket decides what the module needs:

| Change kind | Example | Module action |
|-------------|---------|---------------|
| **Schema-affecting** (settable attr added/changed, validator added/tightened) | forwarder destinations list→set; `password_wo` min length 8 | Mirror into `variables.tf` (new/changed `validation`) **and** add an `expect_failures` regression test; **bump** the module pin. |
| **Correctness fix** (read/decode/plan behavior) | v0.4.0 domain `pointers` now decodes the keyed-object API shape | **Bump** the module pin (the module needs ≥ this version to behave correctly), even with no interface change. Explain *why* in the pin comment. |
| **Doc-only** (description corrected, no behavior change) | `ssl_enabled` is read-only status, not AutoSSL | Mirror the corrected wording into the module's variable/output **description**; **no** pin bump. |
| **Breaking** (attr removed / becomes read-only) | v1.0.0 `limit` becomes read-only | Update inputs/outputs to match; **bump** the pin; a fabric **major** bump if it changes a module interface. |
| **Irrelevant** (resource the fabric doesn't wrap, internal-only) | — | No action. |

### 3. Selectively bump the pins

Bump `version = ">= X.Y.Z"` in a module's `provider.tf` **only** for modules
in the schema-affecting, correctness-fix, or breaking buckets. Leave every
other module's pin at its existing floor — the selective scheme keeps each
module's minimum honest about what it actually requires.

**Carry the *why* in a comment** above the bumped pin, as the existing
modules do (see `modules/mxroute_domain/provider.tf`):

```hcl
    mxroute = {
      source = "harleypig/mxroute"
      # >= 0.4.0: reading a domain with pointers only decodes correctly from
      # this version on (the live API returns pointers as a keyed object, not
      # the documented array of strings), so the pointers output needs it.
      version = ">= 0.4.0"
    }
```

### 4. Mirror doc and validator changes

- **Validator changes** → update the module's `variables.tf` `validation`
  block to mirror the provider's validator, and add a matching
  `expect_failures` case in the module's `tests/*.tftest.hcl` so every
  validator has a failing-input regression (`.claude/TESTS.md`).
- **Doc corrections** → update the affected variable/output **description**
  to the provider's corrected wording. Do not invent wording; copy the intent
  from the provider docs (source of truth).

### 5. Regenerate the READMEs

Any description or variable change makes a module README stale. Regenerate:

```sh
bin/build-docs                 # rewrite every module README in place
bin/build-docs --check         # confirm none are stale (the CI gate)
```

### 6. Re-test against the NEW provider

The lockfile is **gitignored** (`.terraform.lock.hcl`), so a fresh clone or a
plain `terraform init` may resolve an **already-cached older** provider and
silently test against the stale version. Force the upgrade **per touched
module**:

```sh
terraform -chdir=modules/<module> init -upgrade   # pull the new provider
terraform -chdir=modules/<module> test            # plan-only, credential-free
```

Confirm each touched module inits the **new** version, validates, and its
plan-only tests (valid path + every `expect_failures`) pass. Terraform still
loads the real provider schema under `mock_provider`, so `init -upgrade` is
what actually exercises the new schema.

### 7. QA and ship

Run the repo's QA (`qa-check`, which composes `terraform-review` for the
Terraform slice) and open the PR (`push-pr`). The commit message should list,
per module, which bucket each change fell into and why each bump was or was
not made — matching the adoption commits in PRs #11 and #12.

## Notes

- **Never bump a pin without a reason from step 2.** A pin bump with no
  schema-affecting / correctness / breaking change behind it is noise that
  over-constrains a consumer.
- **Never fork the resource shape.** If a module's inputs/outputs no longer
  mirror the provider resource, the fix is to re-sync the module, not to
  diverge.
- The provider CHANGELOG classification (BREAKING / ENHANCEMENTS / BUG FIXES /
  NOTES) maps directly onto the buckets in step 2 — read it before diffing.

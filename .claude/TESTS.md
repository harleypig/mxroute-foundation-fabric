# mxroute-foundation-fabric Test Layout

The global `testing.md` carries the bar (success + failure paths, a regression
test per bug); this file records what exists here and how to run it.

## One tier: credential-free, plan-only

Every module has `tests/*.tftest.hcl` using Terraform's native `terraform test`
framework, **plan-only** (`command = plan`) with `mock_provider "mxroute" {}`.
This needs **no MXroute credentials** and creates **no real infrastructure** —
it is what gates `master`. Real-infrastructure testing is the consuming root
config's job (harleydev), not this library's.

Terraform still loads the **real provider schema** even with `mock_provider`
(the mock replaces behavior, not the schema), so `terraform init` must run
first to install the provider from the Registry.

## What is tested

Per module: a valid `command = plan` run (asserting the resource plans and key
inputs pass through), plus an `expect_failures` run for **each** input
`validation` block — so every validator has a failing-input regression case.

## Running

```sh
# `terraform init` installs the provider from the Registry (per module).
# One module:
terraform -chdir=modules/mxroute_domain init
terraform -chdir=modules/mxroute_domain test

# All modules:
for m in modules/*/; do
  terraform -chdir="$m" init && terraform -chdir="$m" test || exit 1
done
```

## Safety

- **`command = plan` only.** No real resources, no cost, no credentials.
- This library never targets live infrastructure; the consuming root config
  guards that (see harleydev's `TESTS.md`).

## Coverage policy

Cover the valid path **and** a failing case per validation; add a regression
test with each bug fix (`testing.md`).

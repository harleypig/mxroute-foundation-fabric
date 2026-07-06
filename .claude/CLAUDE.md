# mxroute-foundation-fabric — Agent Guide

Auto-loaded entry point for AI agents working in mxroute-foundation-fabric — a
generic, reusable Terraform module library (CFF-style) for MXroute email
hosting, built on the `terraform-provider-mxroute` provider.

## The few things to internalize first

- **This is a library, not live infra.** It holds no account-specific config.
  Modules are validated and plan-tested here; real infrastructure is exercised
  by the consuming root config (harleydev), never here.
- **The provider is the source of truth.** Each module wraps one `mxroute_*`
  resource; inputs mirror its settable attributes, outputs its computed ones.
- **The provider is on the Registry.** Local dev and CI install it with
  `terraform init` from each module's pinned `provider.tf` — see
  `CONVENTIONS.md` *Toolchain*.
- **Tests are credential-free and plan-only** (`mock_provider`,
  `command = plan`). See `TESTS.md`.
- **`master` is PR-only.** Branch first; never commit on `master`.
- **Near-zero-touch** mirrors the harleydev north-star: validated, tested,
  documented modules so the account can be managed as code with minimal touch.

## Where the rest lives

Repo conventions and the QA picture are in [CONVENTIONS.md](CONVENTIONS.md);
the test layout in [TESTS.md](TESTS.md). Generic agent behavior — git/gh
workflow, code style, Terraform tooling, the QA dimensions — comes from the
maintainer's global agent config (`~/.claude/`), which this repo defers to
except where `CONVENTIONS.md` overrides it.

@CONVENTIONS.md
@TESTS.md

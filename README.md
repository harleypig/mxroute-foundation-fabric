# mxroute-foundation-fabric

Reusable, single-resource Terraform modules for [MXroute][mx] email hosting —
a "foundation fabric" (Cloud Foundation Fabric-style) library built on the
[`terraform-provider-mxroute`][prov] provider. Each module wraps exactly one
MXroute provider resource with validated inputs, a factory `for_each`
interface, and plan-only tests.

This repo is **generic and reusable**; it holds no account-specific
configuration. It is consumed by git ref from a root configuration (for
example, [harleydev][hd], which manages the live harleypig.com account).

**Guides:** the [Quick Start](docs/quick-start.md) walks through standing up a
domain, mailbox, and forwarder end to end; [Email
Management](docs/email-management.md) covers mailboxes, forwarders, and spam
filtering in depth.

## Modules

Each module under `modules/` wraps the provider resource of the same name:

| Module | Wraps |
|--------|-------|
| `mxroute_domain` | `mxroute_domain` |
| `mxroute_email_account` | `mxroute_email_account` |
| `mxroute_forwarder` | `mxroute_forwarder` |
| `mxroute_pointer` | `mxroute_pointer` |
| `mxroute_catch_all` | `mxroute_catch_all` |
| `mxroute_spam_settings` | `mxroute_spam_settings` |
| `mxroute_spam_blacklist_entry` | `mxroute_spam_blacklist_entry` |
| `mxroute_spam_whitelist_entry` | `mxroute_spam_whitelist_entry` |
| `mxroute_reseller_package` | `mxroute_reseller_package` |
| `mxroute_reseller_user` | `mxroute_reseller_user` |

## Usage

```hcl
module "domains" {
  source = "github.com/harleypig/mxroute-foundation-fabric//modules/mxroute_domain?ref=v0.1.0"

  domains = {
    primary = { domain = "example.com" }
  }
}
```

## Requirements

- **Terraform >= 1.11** — several modules expose write-only arguments
  (`mxroute_email_account`, `mxroute_reseller_user` passwords), which Terraform
  added in 1.11.
- **The `harleypig/mxroute` provider.** It is not yet published to the
  Terraform Registry; until it is, develop against a local build via a
  dev-override — see [Development](#development).

## Development

The provider is unpublished, so local `terraform` is pointed at a locally
built binary through a dev-override:

```sh
# 1. Build the provider binary into .dev/ (the dev-override target).
( cd ../terraform-provider-mxroute && \
    go build -o ../mxroute-foundation-fabric/.dev/terraform-provider-mxroute . )

# 2. Point Terraform at it and run a module's plan-only tests.
export TF_CLI_CONFIG_FILE="$PWD/dev.tfrc"
terraform -chdir=modules/mxroute_domain test
```

A dev-override makes Terraform skip `init` for the provider and print a
warning — that is expected. See [`dev.tfrc`](dev.tfrc) and
[`.claude/TESTS.md`](.claude/TESTS.md).

[mx]: https://mxroute.com
[prov]: https://github.com/harleypig/terraform-provider-mxroute
[hd]: https://github.com/harleypig/harleydev

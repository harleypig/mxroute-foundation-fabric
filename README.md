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
  source = "github.com/harleypig/mxroute-foundation-fabric//modules/mxroute_domain?ref=v1.0.0"

  domains = {
    primary = { domain = "example.com" }
  }
}
```

## Requirements

- **Terraform >= 1.11** — several modules expose write-only arguments
  (`mxroute_email_account`, `mxroute_reseller_user` passwords), which Terraform
  added in 1.11.
- **The `harleypig/mxroute` provider.** It is published to the Terraform
  Registry, so `terraform init` installs it automatically.

## Development

The provider is on the Terraform Registry, so local `terraform init` installs
it from each module's pinned version constraint before its plan-only tests run:

```sh
terraform -chdir=modules/mxroute_domain init
terraform -chdir=modules/mxroute_domain test
```

See [`.claude/TESTS.md`](.claude/TESTS.md) for the full test layout.

[mx]: https://mxroute.com
[prov]: https://github.com/harleypig/terraform-provider-mxroute
[hd]: https://github.com/harleypig/harleydev

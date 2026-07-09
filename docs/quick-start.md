# Quick Start

Stand up a working MXroute domain — with a mailbox and a forwarder — using
these Terraform modules. It mirrors MXroute's own [Quick Setup][mx-quick]
(add a domain → create accounts → connect a client), but expressed as
Terraform.

**Scope — read this first.** These modules manage the **MXroute account
side** (the domain, mailboxes, forwarders, …) through the MXroute API. They do
**not** manage **DNS records** (MX / SPF / DKIM / DMARC): those live with
whoever hosts your domain's DNS, and you set them there separately (see [DNS
records](#dns-records-set-these-at-your-dns-provider) below). So this guide
gets mail *provisioned* on MXroute; DNS is what makes it *deliver*.

## Prerequisites

- **Terraform >= 1.11.** Mailbox passwords use write-only arguments, which
  Terraform added in 1.11.
- **An MXroute account and API key.** The provider authenticates with your
  server hostname, DirectAdmin username, and API key. Export them so the
  provider (and this guide's commands) can read them:

  ```sh
  export MXROUTE_SERVER="your-server.mxrouting.net"
  export MXROUTE_USERNAME="your-directadmin-user"
  export MXROUTE_API_KEY="…"   # keep this out of shell history / files
  ```

- **The `harleypig/mxroute` provider.** It is published to the [Terraform
  Registry][reg], so `terraform init` installs it automatically from the
  version constraint in your configuration.

## 1. Configure the provider

```hcl
terraform {
  required_version = ">= 1.11"

  required_providers {
    mxroute = {
      source  = "harleypig/mxroute"
      version = "~> 0.1"
    }
  }
}

# Credentials come from the MXROUTE_SERVER / MXROUTE_USERNAME / MXROUTE_API_KEY
# environment variables, so the block is empty.
provider "mxroute" {}
```

## 2. Add a domain

The `mxroute_domain` module manages the domains on your account. It takes a
map keyed by an identifier you choose (used as the resource key), so one module
call manages many domains.

```hcl
module "domains" {
  source = "github.com/harleypig/mxroute-foundation-fabric//modules/mxroute_domain?ref=v1.0.0"

  domains = {
    primary = {
      domain       = "example.com"
      mail_hosting = true
    }
  }
}
```

> Adding a domain on MXroute requires a one-time **DNS TXT verification** (the
> panel shows the record). That, like all DNS, is done at your DNS provider —
> not through these modules.

## 3. Create email accounts

The `mxroute_email_account` module manages mailboxes. Each entry's key is the
mailbox's local part. The **password is write-only** — Terraform never stores
it in state — so supply it from a sensitive variable, never a literal in the
config.

```hcl
variable "mailbox_passwords" {
  description = "Mailbox passwords, keyed to match the email_accounts entries."
  type        = map(string)
  sensitive   = true
}

module "email_accounts" {
  source = "github.com/harleypig/mxroute-foundation-fabric//modules/mxroute_email_account?ref=v1.0.0"

  email_accounts = {
    alice = {
      domain      = "example.com"
      username    = "alice"
      password_wo = var.mailbox_passwords["alice"]
      quota       = 5120 # MB; omit for unlimited
    }
  }
}
```

Provide the password at apply time via an environment variable (so it never
lands in a file):

```sh
export TF_VAR_mailbox_passwords='{"alice":"a-strong-password"}'
```

## 4. Add forwarders

The `mxroute_forwarder` module manages aliases that forward to one or more
addresses. A `postmaster` alias is a good first forwarder — [RFC 2142][rfc2142]
expects every mail domain to accept `postmaster@`.

```hcl
module "forwarders" {
  source = "github.com/harleypig/mxroute-foundation-fabric//modules/mxroute_forwarder?ref=v1.0.0"

  forwarders = {
    postmaster = {
      domain       = "example.com"
      alias        = "postmaster"
      destinations = ["alice@example.com"]
    }
  }
}
```

## 5. Initialize and apply

```sh
terraform init     # fetches the modules; the provider comes from the override
terraform plan     # review what will be created
terraform apply
```

`plan`/`apply` reach the live MXroute API, so the `MXROUTE_*` variables above
must be set. `apply` changes your real account — review the plan first.

## DNS records (set these at your DNS provider)

Provisioning the account is only half the job — mail won't flow until your
domain's DNS points at MXroute. Set these where your DNS is hosted (they are
**not** managed by these modules):

- **MX** — two records, priority 10 and 20, at `your-server.mxrouting.net` /
  `your-server-relay.mxrouting.net` (exact values in your MXroute panel).
- **SPF** — a TXT record: `v=spf1 include:mxroute.com -all`.
- **DKIM** — the domain's key from the panel, as a TXT record at
  `x._domainkey`.
- **DMARC** — a TXT record at `_dmarc` (start at `p=none` and tighten).

See MXroute's [Quick Setup][mx-quick] for the authoritative record values and
propagation notes (DNS changes can take up to 24–48h). If your DNS is on
Linode, the [linode-foundation-fabric][lff] `linode_domain_record` module
manages these records the same way this library manages the account.

Once DNS resolves, connect a mail client with the standard MXroute ports —
IMAP `993`/`143`, POP3 `995`/`110`, SMTP `465`/`587`/`25` — using the mailbox
you created.

## Next steps

This guide covers the core three modules. The library also wraps catch-all
policy, spam settings/black- & white-lists, domain pointers, and reseller
packages/users — see the [module list](../README.md#modules), each with its
own README and examples.

[mx-quick]: https://docs.mxroute.com/docs/quick-setup.html
[reg]: https://registry.terraform.io/providers/harleypig/mxroute/latest
[lff]: https://github.com/harleypig/linode-foundation-fabric
[rfc2142]: https://www.rfc-editor.org/rfc/rfc2142

# Email Management

Manage the day-to-day mail objects on an MXroute domain — **mailboxes**,
**forwarders**, and **spam filtering** — with these Terraform modules. It
covers the same ground as MXroute's [Email Accounts][mx-accounts], [Email
Forwarders][mx-forwarders], and [Expert Spam Filtering][mx-esf] guides, but as
Terraform.

New to the library? Start with the [Quick Start](quick-start.md) — it sets up
the provider (installed from the Terraform Registry) and stands up a first
domain. The examples below assume that provider configuration and a managed
domain.

As always, these modules manage the **MXroute account side** through the API;
DNS records (MX / SPF / DKIM / DMARC) are set at your DNS provider — see the
Quick Start's [DNS records](quick-start.md#dns-records-set-these-at-your-dns-provider)
section.

## Mailboxes

A mailbox is an email account on a domain — a username, a password, and a
storage quota ([MXroute: Email Accounts][mx-accounts]). The
`mxroute_email_account` module manages them.

The **password is write-only**: Terraform never records it in state, so it
must come from a sensitive variable, never a literal. `quota` is the storage
limit in MB (omit for unlimited); the optional `limit` caps sending. See the
[module README](../modules/mxroute_email_account/README.md) for the full field
reference.

```hcl
variable "mailbox_passwords" {
  type      = map(string)
  sensitive = true
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

Changing a mailbox's `quota` (or rotating its password via
`password_wo_version`) is a normal `plan` / `apply` — the same edit-then-apply
loop the panel does by hand.

## Forwarders

A forwarder (alias) redirects mail sent to one address to one or more
destinations, on the same or an external domain ([MXroute: Email
Forwarders][mx-forwarders]). The `mxroute_forwarder` module manages them;
`destinations` is a list, so a single alias can fan out to several addresses.

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

MXroute's guidance applies: **test forwarders after applying**, and **avoid
forwarding loops** (chains that route back to themselves). A forwarder targets
a *specific* alias — distinct from a **catch-all**, which decides what happens
to mail sent to *undefined* addresses on the domain (managed by the separate
[`mxroute_catch_all`](../modules/mxroute_catch_all/README.md) module).

## Spam filtering

MXroute has two distinct spam controls. One is Terraform-managed by this
library; the other is not — know which is which.

### SpamAssassin scoring and lists (Terraform-managed)

Per-domain SpamAssassin scoring plus black/whitelists, managed by three
modules:

- **`mxroute_spam_settings`** — `high_score`, the spam-score threshold
  (`1`–`50`); mail scoring at or above it is treated as spam, so a lower value
  filters more aggressively.
- **`mxroute_spam_blacklist_entry`** / **`mxroute_spam_whitelist_entry`** —
  per-domain `entry` patterns (an address or pattern) to always reject or
  always allow.

```hcl
module "spam_settings" {
  source = "github.com/harleypig/mxroute-foundation-fabric//modules/mxroute_spam_settings?ref=v1.0.0"

  spam_settings = {
    example = { domain = "example.com", high_score = 5 }
  }
}

module "spam_whitelist" {
  source = "github.com/harleypig/mxroute-foundation-fabric//modules/mxroute_spam_whitelist_entry?ref=v1.0.0"

  whitelist_entries = {
    newsletter = { domain = "example.com", entry = "news@trusted.example" }
  }
}
```

See each module's README for the exact field semantics and value ranges.

### Expert Spam Filtering (not managed here)

**Expert Spam Filtering (ESF)** is a separate, **binary per-domain toggle**:
it rejects unauthenticated mail arriving from suspicious IP ranges (botnets,
compromised networks) at the SMTP level, and is enabled by default
([MXroute: Expert Spam Filtering][mx-esf]).

ESF is **not exposed by the `harleypig/mxroute` provider**, so **these modules
do not manage it**. Toggle it in the DirectAdmin panel (Spam Filters →
Advanced), and request whitelist exceptions for legitimately-blocked senders at
<https://esf.mxroute.com>. It is independent of the SpamAssassin scoring above —
changing `high_score` does not affect ESF, and vice versa.

## See also

- [Quick Start](quick-start.md) — provider setup and a first domain.
- The [module list](../README.md#modules) — every module, each with its own
  README and examples (catch-all, pointers, reseller packages/users, …).

[mx-accounts]: https://docs.mxroute.com/docs/email-accounts.html
[mx-forwarders]: https://docs.mxroute.com/docs/email-forwarders.html
[mx-esf]: https://docs.mxroute.com/docs/expert-spam-filtering.html

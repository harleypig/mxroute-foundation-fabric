# mxroute_spam_whitelist_entry

Reusable Terraform module wrapping the `mxroute_spam_whitelist_entry` MXroute provider resource.
Takes a `map(object(...))` and manages one resource per entry (factory
pattern); outputs are maps keyed by the same input key.

> **Known limitation:** spam **writes** currently fail with `HTTP 500` on the
> MXroute API (the spam data sources read fine) — a documented provider
> limitation (mxroute >= 1.0.0) pending an MXroute fix. Plans succeed; an
> apply against the live API will error until MXroute resolves it.

<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-capture -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_mxroute"></a> [mxroute](#requirement\_mxroute) | >= 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mxroute"></a> [mxroute](#provider\_mxroute) | >= 1.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [mxroute_spam_whitelist_entry.whitelist_entries](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/spam_whitelist_entry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_whitelist_entries"></a> [whitelist\_entries](#input\_whitelist\_entries) | Spam whitelist entries to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    domain = string<br/>    entry  = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_entry_ids"></a> [entry\_ids](#output\_entry\_ids) | Map of each input key to the managed entry's id (`<domain>/<entry>`). |
<!-- markdownlint-restore -->
<!-- END_TF_DOCS -->

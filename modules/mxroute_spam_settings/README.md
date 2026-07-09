# mxroute_spam_settings

Reusable Terraform module wrapping the `mxroute_spam_settings` MXroute provider resource.
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
| [mxroute_spam_settings.spam_settings](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/spam_settings) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_spam_settings"></a> [spam\_settings](#input\_spam\_settings) | Per-domain spam settings to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    domain     = string<br/>    high_score = number<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_spam_settings_ids"></a> [spam\_settings\_ids](#output\_spam\_settings\_ids) | Map of each input key to the managed spam settings' id (the domain name). |
<!-- markdownlint-restore -->
<!-- END_TF_DOCS -->

# mxroute_spam_blacklist_entry

Reusable Terraform module wrapping the `mxroute_spam_blacklist_entry` MXroute provider resource.
Takes a `map(object(...))` and manages one resource per entry (factory
pattern); outputs are maps keyed by the same input key.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_mxroute"></a> [mxroute](#requirement\_mxroute) | >= 0.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mxroute"></a> [mxroute](#provider\_mxroute) | >= 0.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [mxroute_spam_blacklist_entry.blacklist_entries](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/spam_blacklist_entry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blacklist_entries"></a> [blacklist\_entries](#input\_blacklist\_entries) | Spam blacklist entries to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    domain = string<br/>    entry  = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_entry_ids"></a> [entry\_ids](#output\_entry\_ids) | Map of each input key to the managed blacklist entry's id (`<domain>/<entry>`). |
<!-- END_TF_DOCS -->

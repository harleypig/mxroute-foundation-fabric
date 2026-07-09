# mxroute_reseller_user

Reusable Terraform module wrapping the `mxroute_reseller_user` MXroute provider resource.
Takes a `map(object(...))` and manages one resource per entry (factory
pattern); outputs are maps keyed by the same input key.

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
| [mxroute_reseller_user.users](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/reseller_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_users"></a> [users](#input\_users) | Reseller-managed users to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    username            = string<br/>    email               = string<br/>    package             = string<br/>    password_wo         = optional(string)<br/>    password_wo_version = optional(number)<br/>    quota               = optional(string)<br/>    suspended           = optional(bool)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domains"></a> [domains](#output\_domains) | Map of each input key to the user's primary domain. |
| <a name="output_ids"></a> [ids](#output\_ids) | Map of each input key to the managed user's id (the username). |
| <a name="output_quota_limit"></a> [quota\_limit](#output\_quota\_limit) | Map of each input key to the user's storage quota limit in megabytes (null when unlimited). |
| <a name="output_quota_unlimited"></a> [quota\_unlimited](#output\_quota\_unlimited) | Map of each input key to whether the user's quota is unlimited. |
| <a name="output_quota_used"></a> [quota\_used](#output\_quota\_used) | Map of each input key to the user's current storage usage in megabytes. |
<!-- markdownlint-restore -->
<!-- END_TF_DOCS -->

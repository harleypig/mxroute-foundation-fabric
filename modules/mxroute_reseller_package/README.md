# mxroute_reseller_package

Reusable Terraform module wrapping the `mxroute_reseller_package` MXroute provider resource.
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
| [mxroute_reseller_package.packages](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/reseller_package) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_packages"></a> [packages](#input\_packages) | Reseller packages to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    name             = string<br/>    quota            = optional(string)<br/>    domains          = optional(string)<br/>    email_accounts   = optional(string)<br/>    email_forwarders = optional(string)<br/>    domain_pointers  = optional(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_package_ids"></a> [package\_ids](#output\_package\_ids) | Map of each input key to the managed package's id (the package name). |
| <a name="output_settings"></a> [settings](#output\_settings) | Map of each input key to the package's computed settings (the typed limits MXroute parsed from the configured strings). |
<!-- END_TF_DOCS -->

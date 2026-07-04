# mxroute_catch_all

Reusable Terraform module wrapping the `mxroute_catch_all` MXroute provider resource.
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
| [mxroute_catch_all.catch_alls](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/catch_all) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_catch_alls"></a> [catch\_alls](#input\_catch\_alls) | Per-domain catch-all policies to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    domain  = string<br/>    type    = string<br/>    address = optional(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catch_all_ids"></a> [catch\_all\_ids](#output\_catch\_all\_ids) | Map of each input key to the managed catch-all policy's id (the domain name). |
| <a name="output_descriptions"></a> [descriptions](#output\_descriptions) | Map of each input key to the catch-all policy's server-reported description. |
<!-- END_TF_DOCS -->

# mxroute_pointer

Reusable Terraform module wrapping the `mxroute_pointer` MXroute provider resource.
Takes a `map(object(...))` and manages one resource per entry (factory
pattern); outputs are maps keyed by the same input key.

<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-capture -->
<!-- markdownlint-disable -->
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
| [mxroute_pointer.pointers](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/pointer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pointers"></a> [pointers](#input\_pointers) | Domain pointers (aliases or redirects) to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    domain  = string<br/>    pointer = string<br/>    alias   = optional(bool)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pointer_ids"></a> [pointer\_ids](#output\_pointer\_ids) | Map of each input key to the managed pointer's id (`<domain>/<pointer>`). |
| <a name="output_targets"></a> [targets](#output\_targets) | Map of each input key to the target the pointer resolves to. |
| <a name="output_types"></a> [types](#output\_types) | Map of each input key to the pointer type reported by the API (`alias` or `redirect`). |
<!-- markdownlint-restore -->
<!-- END_TF_DOCS -->

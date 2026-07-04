# mxroute_forwarder

Reusable Terraform module wrapping the `mxroute_forwarder` MXroute provider resource.
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
| [mxroute_forwarder.forwarders](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/forwarder) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_forwarders"></a> [forwarders](#input\_forwarders) | Email forwarders (aliases) to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    domain       = string<br/>    alias        = string<br/>    destinations = list(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_emails"></a> [emails](#output\_emails) | Map of each input key to the full forwarding address (`<alias>@<domain>`). |
| <a name="output_forwarder_ids"></a> [forwarder\_ids](#output\_forwarder\_ids) | Map of each input key to the managed forwarder's id (`<domain>/<alias>`). |
<!-- END_TF_DOCS -->

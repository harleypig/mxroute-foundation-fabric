# mxroute_domain

Reusable Terraform module wrapping the `mxroute_domain` MXroute provider resource.
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
| [mxroute_domain.domains](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/domain) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domains"></a> [domains](#input\_domains) | Mail domains to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    domain       = string<br/>    mail_hosting = optional(bool)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_ids"></a> [domain\_ids](#output\_domain\_ids) | Map of each input key to the managed domain's id (the domain name). |
| <a name="output_pointers"></a> [pointers](#output\_pointers) | Map of each input key to the domain's pointers (aliases). |
| <a name="output_ssl_enabled"></a> [ssl\_enabled](#output\_ssl\_enabled) | Map of each input key to whether SSL is enabled (server-managed via MXroute AutoSSL). |
<!-- markdownlint-restore -->
<!-- END_TF_DOCS -->

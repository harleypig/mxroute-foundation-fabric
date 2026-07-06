# mxroute_email_account

Reusable Terraform module wrapping the `mxroute_email_account` MXroute provider resource.
Takes a `map(object(...))` and manages one resource per entry (factory
pattern); outputs are maps keyed by the same input key.

<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-capture -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_mxroute"></a> [mxroute](#requirement\_mxroute) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mxroute"></a> [mxroute](#provider\_mxroute) | >= 0.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [mxroute_email_account.email_accounts](https://registry.terraform.io/providers/harleypig/mxroute/latest/docs/resources/email_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_email_accounts"></a> [email\_accounts](#input\_email\_accounts) | Email accounts (mailboxes) to manage, keyed by an arbitrary identifier. | <pre>map(object({<br/>    domain              = string<br/>    username            = string<br/>    password_wo         = optional(string)<br/>    password_wo_version = optional(number)<br/>    quota               = optional(number)<br/>    limit               = optional(number)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_emails"></a> [emails](#output\_emails) | Map of each input key to the mailbox's full email address (username@domain). |
| <a name="output_ids"></a> [ids](#output\_ids) | Map of each input key to the resource identifier (domain/username). |
| <a name="output_sent"></a> [sent](#output\_sent) | Map of each input key to the number of messages sent in the current window. |
| <a name="output_suspended"></a> [suspended](#output\_suspended) | Map of each input key to whether the mailbox is suspended. |
| <a name="output_usage"></a> [usage](#output\_usage) | Map of each input key to the mailbox's current storage usage in megabytes. |
<!-- markdownlint-restore -->
<!-- END_TF_DOCS -->

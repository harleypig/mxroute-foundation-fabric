output "emails" {
  value       = { for key, account in mxroute_email_account.email_accounts : key => account.email }
  description = "Map of each input key to the mailbox's full email address (username@domain)."
}

output "usage" {
  value       = { for key, account in mxroute_email_account.email_accounts : key => account.usage }
  description = "Map of each input key to the mailbox's current storage usage in megabytes."
}

output "sent" {
  value       = { for key, account in mxroute_email_account.email_accounts : key => account.sent }
  description = "Map of each input key to the number of messages sent in the current window."
}

output "suspended" {
  value       = { for key, account in mxroute_email_account.email_accounts : key => account.suspended }
  description = "Map of each input key to whether the mailbox is suspended."
}

output "ids" {
  value       = { for key, account in mxroute_email_account.email_accounts : key => account.id }
  description = "Map of each input key to the resource identifier (domain/username)."
}

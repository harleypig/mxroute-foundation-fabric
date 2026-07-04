variable "whitelist_entries" {
  description = "Spam whitelist entries to manage, keyed by an arbitrary identifier."

  type = map(object({
    domain = string
    entry  = string
  }))

  validation {
    condition     = alltrue([for obj in values(var.whitelist_entries) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", obj.domain))])
    error_message = "Each domain must be a valid fully-qualified domain name."
  }

  validation {
    condition     = alltrue([for obj in values(var.whitelist_entries) : length(obj.entry) > 0])
    error_message = "Each entry must be a non-empty whitelist pattern."
  }
}

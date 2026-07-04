variable "catch_alls" {
  description = "Per-domain catch-all policies to manage, keyed by an arbitrary identifier."

  type = map(object({
    domain  = string
    type    = string
    address = optional(string)
  }))

  validation {
    condition     = alltrue([for obj in values(var.catch_alls) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,}$", obj.domain))])
    error_message = "Each domain must be a valid fully-qualified domain name."
  }

  validation {
    condition     = alltrue([for obj in values(var.catch_alls) : contains(["fail", "blackhole", "address"], obj.type)])
    error_message = "Each type must be one of: fail, blackhole, address."
  }

  validation {
    condition     = alltrue([for obj in values(var.catch_alls) : (obj.type == "address") == (obj.address != null)])
    error_message = "address must be set when type is \"address\" and null otherwise."
  }
}

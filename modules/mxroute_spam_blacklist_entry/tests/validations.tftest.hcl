# Plan-only tests for the mxroute_spam_blacklist_entry module. command = plan
# never creates real infrastructure; mock_provider satisfies provider config so
# no MXroute credentials are needed. Terraform still loads the real provider
# schema from the Registry, so run `terraform init` first.
#
# Run: terraform -chdir=modules/mxroute_spam_blacklist_entry init && \
#        terraform -chdir=modules/mxroute_spam_blacklist_entry test

mock_provider "mxroute" {}

variables {
  blacklist_entries = {
    primary = {
      domain = "example.com"
      entry  = "spammer@example.net"
    }
  }
}

run "valid_entry_plans" {
  command = plan

  assert {
    condition     = length(mxroute_spam_blacklist_entry.blacklist_entries) == 1
    error_message = "expected exactly one planned blacklist entry"
  }
}

run "attrs_pass_through" {
  command = plan

  assert {
    condition     = mxroute_spam_blacklist_entry.blacklist_entries["primary"].domain == "example.com"
    error_message = "the configured domain should pass through to the resource"
  }

  assert {
    condition     = mxroute_spam_blacklist_entry.blacklist_entries["primary"].entry == "spammer@example.net"
    error_message = "the configured entry should pass through to the resource"
  }
}

run "rejects_bad_domain" {
  command = plan

  variables {
    blacklist_entries = {
      bad = {
        domain = "not a domain"
        entry  = "spammer@example.net"
      }
    }
  }

  expect_failures = [var.blacklist_entries]
}

run "rejects_empty_entry" {
  command = plan

  variables {
    blacklist_entries = {
      bad = {
        domain = "example.com"
        entry  = ""
      }
    }
  }

  expect_failures = [var.blacklist_entries]
}

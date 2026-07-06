# Plan-only tests for the mxroute_spam_whitelist_entry module. command = plan
# never creates real infrastructure; mock_provider satisfies provider config so
# no MXroute credentials are needed. Terraform still loads the real provider
# schema from the Registry, so run `terraform init` first.
#
# Run: terraform -chdir=modules/mxroute_spam_whitelist_entry init && \
#        terraform -chdir=modules/mxroute_spam_whitelist_entry test

mock_provider "mxroute" {}

variables {
  whitelist_entries = {
    trusted = {
      domain = "example.com"
      entry  = "*@trusted.com"
    }
  }
}

run "valid_entry_plans" {
  command = plan

  assert {
    condition     = length(mxroute_spam_whitelist_entry.whitelist_entries) == 1
    error_message = "expected exactly one planned whitelist entry"
  }
}

run "entry_passes_through" {
  command = plan

  assert {
    condition     = mxroute_spam_whitelist_entry.whitelist_entries["trusted"].domain == "example.com"
    error_message = "the configured domain should pass through to the resource"
  }

  assert {
    condition     = mxroute_spam_whitelist_entry.whitelist_entries["trusted"].entry == "*@trusted.com"
    error_message = "the configured entry should pass through to the resource"
  }
}

run "rejects_bad_domain" {
  command = plan

  variables {
    whitelist_entries = {
      bad = {
        domain = "not a domain"
        entry  = "*@trusted.com"
      }
    }
  }

  expect_failures = [var.whitelist_entries]
}

run "rejects_empty_entry" {
  command = plan

  variables {
    whitelist_entries = {
      bad = {
        domain = "example.com"
        entry  = ""
      }
    }
  }

  expect_failures = [var.whitelist_entries]
}

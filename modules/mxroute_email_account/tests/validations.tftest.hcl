# Plan-only tests for the mxroute_email_account module. command = plan never
# creates real infrastructure; mock_provider satisfies provider config so no
# MXroute credentials are needed. Terraform still loads the real provider
# schema from the Registry, so run `terraform init` first. password_wo is
# a write-only attribute, so this needs Terraform >= 1.11 (provider.tf
# already sets that).
#
# Run: terraform -chdir=modules/mxroute_email_account init && \
#        terraform -chdir=modules/mxroute_email_account test

mock_provider "mxroute" {}

variables {
  email_accounts = {
    primary = {
      domain      = "example.com"
      username    = "postmaster"
      password_wo = "s3cr3t-p4ssw0rd"
    }
  }
}

run "valid_account_plans" {
  command = plan

  assert {
    condition     = length(mxroute_email_account.email_accounts) == 1
    error_message = "expected exactly one planned email account"
  }
}

run "account_passes_through" {
  command = plan

  assert {
    condition     = mxroute_email_account.email_accounts["primary"].domain == "example.com"
    error_message = "the configured domain should pass through to the resource"
  }
}

run "rejects_bad_domain" {
  command = plan

  variables {
    email_accounts = {
      bad = {
        domain      = "not a domain"
        username    = "postmaster"
        password_wo = "s3cr3t-p4ssw0rd"
      }
    }
  }

  expect_failures = [var.email_accounts]
}

run "rejects_empty_username" {
  command = plan

  variables {
    email_accounts = {
      bad = {
        domain      = "example.com"
        username    = ""
        password_wo = "s3cr3t-p4ssw0rd"
      }
    }
  }

  expect_failures = [var.email_accounts]
}

run "password_wo_is_optional" {
  command = plan

  # An existing mailbox may omit password_wo (the provider requires it only on
  # create). This plans cleanly against the provider (>= 0.3.0) where the
  # attribute is optional.
  variables {
    email_accounts = {
      existing = {
        domain              = "example.com"
        username            = "postmaster"
        password_wo_version = 1
        quota               = 2048
      }
    }
  }

  assert {
    condition     = mxroute_email_account.email_accounts["existing"].domain == "example.com"
    error_message = "an account that omits password_wo should still plan"
  }
}

run "rejects_short_password" {
  command = plan

  # password_wo has a minimum length of 8 (mirrors provider >= 0.3.0).
  variables {
    email_accounts = {
      bad = {
        domain      = "example.com"
        username    = "postmaster"
        password_wo = "short"
      }
    }
  }

  expect_failures = [var.email_accounts]
}

run "rejects_limit_over_max" {
  command = plan

  # limit has an upper bound of 9600 (mirrors provider >= 0.3.0).
  variables {
    email_accounts = {
      bad = {
        domain      = "example.com"
        username    = "postmaster"
        password_wo = "s3cr3t-p4ssw0rd"
        limit       = 9601
      }
    }
  }

  expect_failures = [var.email_accounts]
}

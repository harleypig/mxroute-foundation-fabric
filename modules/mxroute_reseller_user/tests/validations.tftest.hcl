# Plan-only tests for the mxroute_reseller_user module. command = plan never
# creates real infrastructure; mock_provider satisfies provider config so no
# MXroute credentials are needed. Terraform still loads the real provider
# schema from the Registry, so run `terraform init` first.
#
# Run: terraform -chdir=modules/mxroute_reseller_user init && \
#        terraform -chdir=modules/mxroute_reseller_user test

mock_provider "mxroute" {}

variables {
  users = {
    primary = {
      username    = "alice"
      email       = "alice@example.com"
      package     = "starter"
      password_wo = "s3cr3t-p@ss"
    }
  }
}

run "valid_user_plans" {
  command = plan

  assert {
    condition     = length(mxroute_reseller_user.users) == 1
    error_message = "expected exactly one planned user"
  }
}

run "user_passes_through" {
  command = plan

  assert {
    condition     = mxroute_reseller_user.users["primary"].username == "alice"
    error_message = "the configured username should pass through to the resource"
  }
}

run "rejects_bad_email" {
  command = plan

  variables {
    users = {
      bad = {
        username    = "bob"
        email       = "not an email"
        package     = "starter"
        password_wo = "s3cr3t-p@ss"
      }
    }
  }

  expect_failures = [var.users]
}

run "rejects_empty_username" {
  command = plan

  variables {
    users = {
      bad = {
        username    = ""
        email       = "carol@example.com"
        package     = "starter"
        password_wo = "s3cr3t-p@ss"
      }
    }
  }

  expect_failures = [var.users]
}

run "password_wo_is_optional" {
  command = plan

  # An existing user may omit password_wo (the provider requires it only on
  # create). This plans cleanly against the provider (>= 0.3.0) where the
  # attribute is optional.
  variables {
    users = {
      existing = {
        username            = "alice"
        email               = "alice@example.com"
        package             = "starter"
        password_wo_version = 1
      }
    }
  }

  assert {
    condition     = mxroute_reseller_user.users["existing"].username == "alice"
    error_message = "a user that omits password_wo should still plan"
  }
}

run "rejects_short_password" {
  command = plan

  # password_wo has a minimum length of 8 (mirrors provider >= 0.3.0).
  variables {
    users = {
      bad = {
        username    = "bob"
        email       = "bob@example.com"
        package     = "starter"
        password_wo = "short"
      }
    }
  }

  expect_failures = [var.users]
}

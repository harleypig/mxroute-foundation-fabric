# Plan-only tests for the mxroute_reseller_user module. command = plan never
# creates real infrastructure; mock_provider satisfies provider config so no
# MXroute credentials are needed. Terraform still loads the real provider
# schema (via the dev_override), so the binary must be built first — see
# ../../../dev.tfrc.
#
# Run: TF_CLI_CONFIG_FILE="$PWD/dev.tfrc" \
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

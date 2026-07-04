# Plan-only tests for the mxroute_spam_settings module. command = plan never
# creates real infrastructure; mock_provider satisfies provider config so no
# MXroute credentials are needed. Terraform still loads the real provider
# schema (via the dev_override), so the binary must be built first — see
# ../../../dev.tfrc.
#
# Run: TF_CLI_CONFIG_FILE="$PWD/dev.tfrc" \
#        terraform -chdir=modules/mxroute_spam_settings test

mock_provider "mxroute" {}

variables {
  spam_settings = {
    primary = {
      domain     = "example.com"
      high_score = 10
    }
  }
}

run "valid_spam_settings_plans" {
  command = plan

  assert {
    condition     = length(mxroute_spam_settings.spam_settings) == 1
    error_message = "expected exactly one planned spam settings entry"
  }
}

run "attributes_pass_through" {
  command = plan

  assert {
    condition     = mxroute_spam_settings.spam_settings["primary"].domain == "example.com"
    error_message = "the configured domain should pass through to the resource"
  }

  assert {
    condition     = mxroute_spam_settings.spam_settings["primary"].high_score == 10
    error_message = "the configured high_score should pass through to the resource"
  }
}

run "rejects_bad_domain" {
  command = plan

  variables {
    spam_settings = {
      bad = {
        domain     = "not a domain"
        high_score = 10
      }
    }
  }

  expect_failures = [var.spam_settings]
}

run "rejects_high_score_below_range" {
  command = plan

  variables {
    spam_settings = {
      low = {
        domain     = "example.com"
        high_score = 0
      }
    }
  }

  expect_failures = [var.spam_settings]
}

run "rejects_high_score_above_range" {
  command = plan

  variables {
    spam_settings = {
      high = {
        domain     = "example.com"
        high_score = 51
      }
    }
  }

  expect_failures = [var.spam_settings]
}

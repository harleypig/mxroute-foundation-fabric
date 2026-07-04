# Plan-only tests for the mxroute_catch_all module. command = plan never
# creates real infrastructure; mock_provider satisfies provider config so no
# MXroute credentials are needed. Terraform still loads the real provider
# schema (via the dev_override), so the binary must be built first — see
# ../../../dev.tfrc.
#
# Run: TF_CLI_CONFIG_FILE="$PWD/dev.tfrc" \
#        terraform -chdir=modules/mxroute_catch_all test

mock_provider "mxroute" {}

variables {
  catch_alls = {
    primary = {
      domain  = "example.com"
      type    = "address"
      address = "postmaster@example.com"
    }
  }
}

run "valid_catch_all_plans" {
  command = plan

  assert {
    condition     = length(mxroute_catch_all.catch_alls) == 1
    error_message = "expected exactly one planned catch-all policy"
  }
}

run "catch_all_passes_through" {
  command = plan

  assert {
    condition     = mxroute_catch_all.catch_alls["primary"].type == "address"
    error_message = "the configured type should pass through to the resource"
  }
}

run "rejects_bad_domain" {
  command = plan

  variables {
    catch_alls = {
      bad = {
        domain = "not a domain"
        type   = "fail"
      }
    }
  }

  expect_failures = [var.catch_alls]
}

run "rejects_bad_type" {
  command = plan

  variables {
    catch_alls = {
      bad = {
        domain = "example.com"
        type   = "bogus"
      }
    }
  }

  expect_failures = [var.catch_alls]
}

run "rejects_address_type_mismatch" {
  command = plan

  variables {
    catch_alls = {
      bad = {
        domain = "example.com"
        type   = "address"
      }
    }
  }

  expect_failures = [var.catch_alls]
}

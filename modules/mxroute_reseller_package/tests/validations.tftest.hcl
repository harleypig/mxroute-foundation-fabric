# Plan-only tests for the mxroute_reseller_package module. command = plan never
# creates real infrastructure; mock_provider satisfies provider config so no
# MXroute credentials are needed. Terraform still loads the real provider schema
# (via the dev_override), so the binary must be built first — see ../../../dev.tfrc.
#
# Run: TF_CLI_CONFIG_FILE="$PWD/dev.tfrc" \
#        terraform -chdir=modules/mxroute_reseller_package test

mock_provider "mxroute" {}

variables {
  packages = {
    starter = {
      name = "starter"
    }
  }
}

run "valid_package_plans" {
  command = plan

  assert {
    condition     = length(mxroute_reseller_package.packages) == 1
    error_message = "expected exactly one planned package"
  }
}

run "name_passes_through" {
  command = plan

  assert {
    condition     = mxroute_reseller_package.packages["starter"].name == "starter"
    error_message = "the configured name should pass through to the resource"
  }
}

run "rejects_empty_name" {
  command = plan

  variables {
    packages = {
      bad = {
        name = ""
      }
    }
  }

  expect_failures = [var.packages]
}

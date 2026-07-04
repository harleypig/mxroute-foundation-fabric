# Plan-only tests for the mxroute_domain module. command = plan never creates
# real infrastructure; mock_provider satisfies provider config so no MXroute
# credentials are needed. Terraform still loads the real provider schema (via
# the dev_override), so the binary must be built first — see ../../../dev.tfrc.
#
# Run: TF_CLI_CONFIG_FILE="$PWD/dev.tfrc" \
#        terraform -chdir=modules/mxroute_domain test

mock_provider "mxroute" {}

variables {
  domains = {
    primary = {
      domain = "example.com"
    }
  }
}

run "valid_domain_plans" {
  command = plan

  assert {
    condition     = length(mxroute_domain.domains) == 1
    error_message = "expected exactly one planned domain"
  }
}

run "domain_passes_through" {
  command = plan

  assert {
    condition     = mxroute_domain.domains["primary"].domain == "example.com"
    error_message = "the configured domain should pass through to the resource"
  }
}

run "rejects_bad_domain" {
  command = plan

  variables {
    domains = {
      bad = {
        domain = "not a domain"
      }
    }
  }

  expect_failures = [var.domains]
}

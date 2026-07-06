# Plan-only tests for the mxroute_pointer module. command = plan never creates
# real infrastructure; mock_provider satisfies provider config so no MXroute
# credentials are needed. Terraform still loads the real provider schema from
# the Registry, so run `terraform init` first.
#
# Run: terraform -chdir=modules/mxroute_pointer init && \
#        terraform -chdir=modules/mxroute_pointer test

mock_provider "mxroute" {}

variables {
  pointers = {
    primary = {
      domain  = "example.com"
      pointer = "www.example.com"
    }
  }
}

run "valid_pointer_plans" {
  command = plan

  assert {
    condition     = length(mxroute_pointer.pointers) == 1
    error_message = "expected exactly one planned pointer"
  }
}

run "pointer_passes_through" {
  command = plan

  assert {
    condition     = mxroute_pointer.pointers["primary"].pointer == "www.example.com"
    error_message = "the configured pointer should pass through to the resource"
  }
}

run "rejects_bad_domain" {
  command = plan

  variables {
    pointers = {
      bad = {
        domain  = "not a domain"
        pointer = "www.example.com"
      }
    }
  }

  expect_failures = [var.pointers]
}

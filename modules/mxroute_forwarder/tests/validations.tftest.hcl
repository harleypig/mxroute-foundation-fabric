# Plan-only tests for the mxroute_forwarder module. command = plan never
# creates real infrastructure; mock_provider satisfies provider config so no
# MXroute credentials are needed. Terraform still loads the real provider
# schema from the Registry, so run `terraform init` first.
#
# Run: terraform -chdir=modules/mxroute_forwarder init && \
#        terraform -chdir=modules/mxroute_forwarder test

mock_provider "mxroute" {}

variables {
  forwarders = {
    sales = {
      domain       = "example.com"
      alias        = "sales"
      destinations = ["owner@example.com"]
    }
  }
}

run "valid_forwarder_plans" {
  command = plan

  assert {
    condition     = length(mxroute_forwarder.forwarders) == 1
    error_message = "expected exactly one planned forwarder"
  }
}

run "forwarder_passes_through" {
  command = plan

  assert {
    condition     = mxroute_forwarder.forwarders["sales"].alias == "sales"
    error_message = "the configured alias should pass through to the resource"
  }
}

run "rejects_bad_domain" {
  command = plan

  variables {
    forwarders = {
      bad = {
        domain       = "not a domain"
        alias        = "sales"
        destinations = ["owner@example.com"]
      }
    }
  }

  expect_failures = [var.forwarders]
}

run "rejects_bad_destination" {
  command = plan

  variables {
    forwarders = {
      bad = {
        domain       = "example.com"
        alias        = "sales"
        destinations = ["not an email"]
      }
    }
  }

  expect_failures = [var.forwarders]
}

run "accepts_fail_and_blackhole_destinations" {
  command = plan

  # The Exim special targets :fail: (reject) and :blackhole: (discard) are
  # valid destinations alongside email addresses.
  variables {
    forwarders = {
      burned = {
        domain       = "example.com"
        alias        = "burned"
        destinations = [":fail:"]
      }
      spam = {
        domain       = "example.com"
        alias        = "spam"
        destinations = [":blackhole:"]
      }
    }
  }

  assert {
    condition     = length(mxroute_forwarder.forwarders) == 2
    error_message = "forwarders with :fail:/:blackhole: destinations should plan"
  }
}

# TODO

## Provider dependency

- [ ] Switch from the dev-override (`dev.tfrc`) to a real Registry provider
  reference once `terraform-provider-mxroute` is published to the Terraform
  Registry. Update `provider.tf` version pins and the CI provider-mirror step.

## Documentation

- [x] Write a Terraform-oriented quick-setup guide modeled on MXroute's
  quick-setup doc (<https://docs.mxroute.com/docs/quick-setup.html>) but geared
  to this module library — walking through standing up domains, email accounts,
  and forwarders with these modules. Consider a dedicated docs/ subdirectory
  structure rather than a single page.

## API tracking

- [ ] Add a way to detect when the MXroute API changes or adds capabilities
  upstream, so the modules (and the provider) can be kept current — e.g. a
  scheduled check against the API docs/spec or a diff of the published schema.

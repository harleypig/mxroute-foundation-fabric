# TODO

## Provider dependency

- [x] Switch from the dev-override (`dev.tfrc`) to a real Registry provider
  reference once `terraform-provider-mxroute` is published to the Terraform
  Registry. Update `provider.tf` version pins and the CI provider-mirror step.

## API tracking

- [ ] Add a way to detect when the MXroute API changes or adds capabilities
  upstream, so the modules (and the provider) can be kept current — e.g. a
  scheduled check against the API docs/spec or a diff of the published schema.

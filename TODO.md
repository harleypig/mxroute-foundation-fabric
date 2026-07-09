# TODO

## API tracking

- [ ] Add a way to detect when the MXroute API changes or adds capabilities
  upstream, so the modules (and the provider) can be kept current — e.g. a
  scheduled check against the API docs/spec or a diff of the published schema.

- [ ] Add a scheduled CI run (e.g. weekly) that `terraform init -upgrade` +
  tests every module against the **latest published provider**, so a new
  provider release that breaks the fabric is caught proactively. Surfaced by
  the v1.0.0 adoption: the unbounded `>= x` pins silently resolved v1.0.0 the
  moment it published, and the breaking change went undetected until an
  unrelated PR happened to run CI. Relates to the API-tracking item above.

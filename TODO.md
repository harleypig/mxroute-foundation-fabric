# TODO

## Provider adoption

- [ ] When the provider ships **v1.0.0** (the 0→1 stability jump), bump
  every module's provider pin uniformly to `>= 1.0.0`, retiring the current
  selective per-module minimum pinning. That per-module minimum-version
  scheme is an alpha-phase convenience (v0.y.z, breakage expected); once the
  provider declares a stable interface, the whole library should track it as
  one floor.

## API tracking

- [ ] Add a way to detect when the MXroute API changes or adds capabilities
  upstream, so the modules (and the provider) can be kept current — e.g. a
  scheduled check against the API docs/spec or a diff of the published schema.

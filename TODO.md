# TODO

## Provider adoption

- [ ] When the provider ships **v1.0.0** (the 0→1 stability jump), bump
  every module's provider pin uniformly to `>= 1.0.0`, retiring the current
  selective per-module minimum pinning. That per-module minimum-version
  scheme is an alpha-phase convenience (v0.y.z, breakage expected); once the
  provider declares a stable interface, the whole library should track it as
  one floor.

- [ ] Propose a **repo-local skill** `adopt-provider-version` for the
  provider→fabric adoption procedure, now done three times (PRs #9, #11,
  #12). The pain: each adoption re-derives the same multi-step sequence by
  hand — diff the sibling `terraform-provider-mxroute` repo between the old
  and new tag, read the CHANGELOG to classify schema-affecting vs doc-only
  changes, selectively bump each module's `provider.tf` pin only where its
  interface (or a correctness fix like the v0.4.0 pointers decode) requires
  it, mirror doc corrections into module descriptions (provider is source of
  truth), regenerate READMEs via `bin/build-docs`, then `terraform init
  -upgrade` (the gitignored lock pins the old version, so a plain `init`
  silently tests against the stale provider) and run the plan-only tests.
  Scope: repo-local (`.claude/skills/`) — it is specific to this repo's
  selective-pinning convention and the sibling-provider layout. Pointer:
  this PR (#12) and the v0.4.0 adoption commit.

## API tracking

- [ ] Add a way to detect when the MXroute API changes or adds capabilities
  upstream, so the modules (and the provider) can be kept current — e.g. a
  scheduled check against the API docs/spec or a diff of the published schema.

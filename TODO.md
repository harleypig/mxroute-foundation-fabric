# TODO

## Provider adoption

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

- [ ] Add a scheduled CI run (e.g. weekly) that `terraform init -upgrade` +
  tests every module against the **latest published provider**, so a new
  provider release that breaks the fabric is caught proactively. Surfaced by
  the v1.0.0 adoption: the unbounded `>= x` pins silently resolved v1.0.0 the
  moment it published, and the breaking change went undetected until an
  unrelated PR happened to run CI. Relates to the API-tracking item above.

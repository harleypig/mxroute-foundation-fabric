// tflint config for the module library. The bundled `terraform` ruleset ships
// inside the tflint binary, so no `tflint --init` / plugin download is needed —
// the recommended preset runs credential-free (no `--deep`, which would call
// the MXroute API). tflint runs recursively over modules/.
config {
  call_module_type = "all"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

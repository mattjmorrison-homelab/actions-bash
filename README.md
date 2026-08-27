# actions-bash

A single reusable GitHub Actions composite action, shared by every repo
in this org that lints or tests bash scripts: installs pinned
`actionlint`, `shellcheck`, and `bats` onto `PATH`. None of these ship on
the runner image by default, and the install steps were previously
copy-pasted verbatim into every consuming workflow (`actions-tofu`,
`actions-helm`, `pi-provision`, `pi-health`, ...) — this puts the tool
versions in one place instead.

See `naming.md` in the `.github` repo for the `actions-` prefix:
destination is other repos' CI, not the cluster or a machine.

## Inputs

None — versions are fixed in `install.sh`. Bump them there; every caller
picks up the change the next time it updates its pin (see below).

## Using it from another repo

```yaml
name: Check

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  check:
    runs-on: k8s-amd64
    steps:
      - uses: actions/checkout@<sha> # v4.2.2
      - uses: mattjmorrison-homelab/actions-bash@<commit-sha>
      - run: shellcheck ./*.sh
      - run: bats test/
```

**Pin to a commit SHA, not a branch** — this org requires
`sha_pinning_required` on every `uses:` reference, including cross-repo
calls to this one. Get the current SHA with:

```sh
gh api repos/mattjmorrison-homelab/actions-bash/commits/main --jq '.sha'
```

Update every caller's pin after any change here that should actually
take effect — an unpinned or stale-pinned caller keeps running whatever
this repo looked like at that commit, not the latest version. No
automation keeps these pins current today; it's a manual step.

## Permissions needed to call this from another repo

Same conclusion already documented in `actions-tofu`'s and
`actions-helm`'s READMEs: nothing extra needs enabling on this org's
current (permissive default) settings.

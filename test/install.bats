#!/usr/bin/env bats

setup() {
  export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
  export FIXTURES_DIR="$BATS_TEST_DIRNAME/fixtures"
  export RUNNER_TEMP="$BATS_TEST_TMPDIR/runner-temp"
  export GITHUB_PATH="$BATS_TEST_TMPDIR/github_path"
  mkdir -p "$RUNNER_TEMP"
  : > "$GITHUB_PATH"
}

@test "installs an executable actionlint" {
  run bash "$BATS_TEST_DIRNAME/../install.sh"
  [ "$status" -eq 0 ]
  [ -x "$RUNNER_TEMP/bin/actionlint" ]
  [ "$("$RUNNER_TEMP/bin/actionlint")" = "fake-actionlint" ]
}

@test "installs an executable shellcheck" {
  run bash "$BATS_TEST_DIRNAME/../install.sh"
  [ "$status" -eq 0 ]
  [ -x "$RUNNER_TEMP/bin/shellcheck" ]
  [ "$("$RUNNER_TEMP/bin/shellcheck")" = "fake-shellcheck" ]
}

@test "installs a working bats symlink" {
  run bash "$BATS_TEST_DIRNAME/../install.sh"
  [ "$status" -eq 0 ]
  [ -x "$RUNNER_TEMP/bin/bats" ]
  [ "$("$RUNNER_TEMP/bin/bats")" = "fake-bats" ]
}

@test "adds RUNNER_TEMP/bin to GITHUB_PATH" {
  run bash "$BATS_TEST_DIRNAME/../install.sh"
  [ "$status" -eq 0 ]
  grep -qx "$RUNNER_TEMP/bin" "$GITHUB_PATH"
}

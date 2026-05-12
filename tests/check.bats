#!/usr/bin/env bats

setup() {
  # shellcheck source=../utils/check.sh
  source "$BATS_TEST_DIRNAME/../utils/check.sh"
  TMP_FILE="$(mktemp)"
  TMP_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TMP_FILE" "$TMP_DIR"
}

@test "check_exist returns 0 for an existing file" {
  run check_exist "$TMP_FILE"
  [ "$status" -eq 0 ]
}

@test "check_exist returns 0 for an existing directory" {
  run check_exist "$TMP_DIR"
  [ "$status" -eq 0 ]
}

@test "check_exist returns 1 for a missing path" {
  run check_exist "/no/such/path/please/9c7e2bf1"
  [ "$status" -eq 1 ]
}

@test "check_folder returns 0 for a directory" {
  run check_folder "$TMP_DIR"
  [ "$status" -eq 0 ]
}

@test "check_folder returns 1 for a regular file" {
  run check_folder "$TMP_FILE"
  [ "$status" -eq 1 ]
}

@test "check_folder returns 1 for a missing path" {
  run check_folder "/no/such/path/please/9c7e2bf1"
  [ "$status" -eq 1 ]
}

@test "check_cmd returns 0 for an installed command" {
  run check_cmd bash
  [ "$status" -eq 0 ]
}

@test "check_cmd returns 1 for a missing command" {
  run check_cmd "this-command-does-not-exist-3f8a1c"
  [ "$status" -eq 1 ]
}

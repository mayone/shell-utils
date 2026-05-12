#!/usr/bin/env bats

setup() {
  # shellcheck source=../utils/cli.sh
  source "$BATS_TEST_DIRNAME/../utils/cli.sh"
}

@test "print_usage emits Usage header" {
  run print_usage "./foo.sh"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "Usage:" ]]
}

@test "print_usage indents lines with the script name" {
  run print_usage "./foo.sh" "bar <X>   do bar" "baz <Y>   do baz"
  [ "$status" -eq 0 ]
  [[ "$output" == *"  ./foo.sh bar <X>   do bar"* ]]
  [[ "$output" == *"  ./foo.sh baz <Y>   do baz"* ]]
}

@test "require_args returns 0 when actual matches expected" {
  run require_args 2 2 "usage hint"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "require_args returns 1 and prints usage to stderr on mismatch" {
  run require_args 1 0 "expected 1 arg"
  [ "$status" -eq 1 ]
  [[ "$output" == *"expected 1 arg"* ]]
}

@test "require_args treats extra args as mismatch too" {
  run require_args 1 3 "expected 1 arg"
  [ "$status" -eq 1 ]
}

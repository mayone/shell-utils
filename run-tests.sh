#!/usr/bin/env bash
#
# Run the bats test suite.

set -euo pipefail

cd "$(dirname "$0")"
bats tests/

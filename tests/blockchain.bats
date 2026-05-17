#!/usr/bin/env bats
#
# Tests for utils/blockchain.sh.
#
# RPC-dependent cases hit live mainnet endpoints and are skipped by
# default. Set BATS_RUN_NETWORK_TESTS=1 to run them.

setup() {
  # shellcheck source=../utils/index.sh
  source "$BATS_TEST_DIRNAME/../utils/index.sh"
}

skip_network() {
  if [[ "${BATS_RUN_NETWORK_TESTS:-0}" != "1" ]]; then
    skip "network-dependent (set BATS_RUN_NETWORK_TESTS=1 to run)"
  fi
}

# ---------------------------------------------------------------------------
# get_rpc_url -- pure lookup, no network.
# ---------------------------------------------------------------------------

@test "get_rpc_url eth points at infura mainnet" {
  run get_rpc_url eth
  [ "$status" -eq 0 ]
  [[ "$output" == *"mainnet.infura.io"* ]]
}

@test "get_rpc_url bsc points at binance" {
  run get_rpc_url bsc
  [ "$status" -eq 0 ]
  [[ "$output" == *"binance"* ]]
}

@test "get_rpc_url polygon points at polygon-rpc" {
  run get_rpc_url polygon
  [ "$status" -eq 0 ]
  [[ "$output" == *"polygon-rpc.com"* ]]
}

@test "get_rpc_url polygonzk points at zkevm" {
  run get_rpc_url polygonzk
  [ "$status" -eq 0 ]
  [[ "$output" == *"zkevm"* ]]
}

@test "get_rpc_url aminox points at alphacarbon" {
  run get_rpc_url aminox
  [ "$status" -eq 0 ]
  [[ "$output" == *"alphacarbon"* ]]
}

# ---------------------------------------------------------------------------
# get_block_number -- RPC, network.
# ---------------------------------------------------------------------------

@test "get_block_number eth returns decimal block height" {
  skip_network
  run get_block_number eth
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[0-9]+$ ]]
}

@test "get_block_number bsc returns decimal block height" {
  skip_network
  run get_block_number bsc
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[0-9]+$ ]]
}

@test "get_block_number polygon returns decimal block height" {
  skip_network
  run get_block_number polygon
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[0-9]+$ ]]
}

@test "get_block_number polygonzk returns decimal block height" {
  skip_network
  run get_block_number polygonzk
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[0-9]+$ ]]
}

# ---------------------------------------------------------------------------
# get_block_number_hex -- RPC, network. Raw eth_blockNumber hex value.
# ---------------------------------------------------------------------------

@test "get_block_number_hex eth returns 0x-prefixed hex" {
  skip_network
  run get_block_number_hex eth
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^0x[0-9a-fA-F]+$ ]]
}

@test "get_block_number_hex bsc returns 0x-prefixed hex" {
  skip_network
  run get_block_number_hex bsc
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^0x[0-9a-fA-F]+$ ]]
}

@test "get_block_number and get_block_number_hex agree for eth" {
  skip_network
  run get_block_number eth
  [ "$status" -eq 0 ]
  local dec="$output"
  run get_block_number_hex eth
  [ "$status" -eq 0 ]
  local hex="$output"
  # Same block (allow +/-1 for a new block landing between the two calls).
  local diff=$(( dec - hex ))
  [ "${diff#-}" -le 1 ]
}

# ---------------------------------------------------------------------------
# get_balance -- RPC, network.
# ---------------------------------------------------------------------------

@test "get_balance eth returns hex value for vitalik.eth" {
  skip_network
  run get_balance eth '"0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"'
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^0x ]]
}

@test "get_balance bsc returns hex value" {
  skip_network
  run get_balance bsc '"0x8894E0a0c962CB723c1976a4421c95949bE2D4E3"'
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^0x ]]
}

# ---------------------------------------------------------------------------
# get_chain_health -- RPC, network.
# ---------------------------------------------------------------------------

@test "get_chain_health eth reports a status" {
  skip_network
  run get_chain_health eth
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "get_chain_health bsc reports a status" {
  skip_network
  run get_chain_health bsc
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

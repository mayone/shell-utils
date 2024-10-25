#!/bin/bash
#
# Blockchain Test.
SOURCE="${BASH_SOURCE[0]:-$0}"  
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"

source $DIR_PATH/../utils/index.sh

test_get_rpc_url() {
  echo "get_rpc_url eth -> $(get_rpc_url eth)"
  echo "get_rpc_url bsc -> $(get_rpc_url bsc)"
  echo "get_rpc_url polygon -> $(get_rpc_url polygon)"
  echo "get_rpc_url aminox -> $(get_rpc_url aminox)"
  echo "get_rpc_url tron -> $(get_rpc_url tron)"
  echo "get_rpc_url solana -> $(get_rpc_url solana)"
}

test_get_block_number() {
  echo "get_block_number eth -> $(get_block_number eth)"
  echo "get_block_number bsc -> $(get_block_number bsc)"
  echo "get_block_number polygon -> $(get_block_number polygon)"
  echo "get_block_number aminox -> $(get_block_number aminox)"
  echo "get_block_number tron -> $(get_block_number tron)"
  echo "get_block_number solana -> $(get_block_number solana)"
}

test_get_raw_tx() {
  # echo "get_raw_tx eth -> $(get_raw_tx eth '"0xc587f45b2bb9311f9b70dc552f962e7d8f9bd4261c077be4580a52897a80da54"')"
  echo "get_raw_tx bsc -> $(get_raw_tx bsc '"0x891481eb65e5bc52434cb002719c07a3c9b7ed810ffac38f208ea3ddff21b825"')"
  echo "get_raw_tx polygon -> $(get_raw_tx polygon '"0xe51c06c9e4c97adf0b9c77f1adf91595afd1130e29c2681510c43eecbcdf8982"')"
  # echo "get_raw_tx aminox -> $(get_raw_tx aminox '"0x0fa10ac933b05c19a8c36b80125c84db69f8e4c674547052864f510a3158876c"')"
  # echo "get_raw_tx tron -> $(get_raw_tx tron '"c07224bd542478ee75a1d295af48ac7eaa1a3e603f22c7c37ae6310bde869bfb"')"
  # echo "get_raw_tx solana -> $(get_raw_tx solana '"4Ti2MeAp4r7ZyNEWVAgH4jDHGFBbWEY5fLKoAoPXUjM3QMXdUUHakWh4RqJCChsf38Szw2orFfnBbu93Cr1iQFhL"')"
}

test_get_tx_receipt() {
  echo "get_tx_receipt eth -> $(get_tx_receipt eth '"0xc587f45b2bb9311f9b70dc552f962e7d8f9bd4261c077be4580a52897a80da54"')"
  echo "get_tx_receipt bsc -> $(get_tx_receipt bsc '"0x891481eb65e5bc52434cb002719c07a3c9b7ed810ffac38f208ea3ddff21b825"')"
  echo "get_tx_receipt polygon -> $(get_tx_receipt polygon '"0xe51c06c9e4c97adf0b9c77f1adf91595afd1130e29c2681510c43eecbcdf8982"')"
  echo "get_tx_receipt aminox -> $(get_tx_receipt aminox '"0x0fa10ac933b05c19a8c36b80125c84db69f8e4c674547052864f510a3158876c"')"
  echo "get_tx_receipt tron -> $(get_tx_receipt tron '"c07224bd542478ee75a1d295af48ac7eaa1a3e603f22c7c37ae6310bde869bfb"')"
  # echo "get_tx_receipt solana -> $(get_tx_receipt solana '"4Ti2MeAp4r7ZyNEWVAgH4jDHGFBbWEY5fLKoAoPXUjM3QMXdUUHakWh4RqJCChsf38Szw2orFfnBbu93Cr1iQFhL"')"
}

# TODO: Finish this test case
test_get_balance() {
  echo "get_balance eth -> $(get_balance eth '"0x36928500Bc1dCd7af6a2B4008875CC336b927D57"')"
  echo "get_balance bsc -> $(get_balance bsc '"0x980A75eCd1309eA12fa2ED87A8744fBfc9b863D5"')"
  echo "get_balance polygon -> $(get_balance polygon '"0x36928500Bc1dCd7af6a2B4008875CC336b927D57"')"
  echo "get_balance aminox -> $(get_balance aminox '"0x36928500Bc1dCd7af6a2B4008875CC336b927D57"')"
  echo "get_balance tron -> $(get_balance tron '"0x36928500Bc1dCd7af6a2B4008875CC336b927D57"')"
  echo "get_balance solana -> $(get_balance solana '"0x36928500Bc1dCd7af6a2B4008875CC336b927D57"')"
}

# TODO: Fix this test case
test_get_chain_health() {
  echo "get_chain_health eth -> $(get_chain_health eth)"
  echo "get_chain_health bsc -> $(get_chain_health bsc)"
  echo "get_chain_health polygon -> $(get_chain_health polygon)"
  echo "get_chain_health aminox -> $(get_chain_health aminox)"
  echo "get_chain_health tron -> $(get_chain_health tron)"
  echo "get_chain_health solana -> $(get_chain_health solana)"
}

main() {
  echo "Test cases of get_rpc_url"
  test_get_rpc_url
  echo ""
  echo "Test cases of get_block_number"
  test_get_block_number
  echo ""
  echo "Test cases of get_raw_tx"
  test_get_raw_tx
  echo ""
  echo "Test cases of get_tx_receipt"
  test_get_tx_receipt
  echo ""
  # echo "Test cases of get_balance"
  # test_get_balance
  # echo ""
  # echo "Test cases of get_chain_health"
  # test_get_chain_health
}

main

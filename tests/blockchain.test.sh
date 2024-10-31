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
  echo "get_rpc_url polygonzk -> $(get_rpc_url polygonzk)"
  echo "get_rpc_url aminox -> $(get_rpc_url aminox)"
  echo "get_rpc_url tron -> $(get_rpc_url tron)"
  echo "get_rpc_url solana -> $(get_rpc_url solana)"
}

test_get_block_number() {
  echo "get_block_number eth -> $(get_block_number eth)"
  echo "get_block_number bsc -> $(get_block_number bsc)"
  echo "get_block_number polygon -> $(get_block_number polygon)"
  echo "get_block_number polygonzk -> $(get_block_number polygonzk)"
  echo "get_block_number aminox -> $(get_block_number aminox)"
  echo "get_block_number tron -> $(get_block_number tron)"
  echo "get_block_number solana -> $(get_block_number solana)"
}

test_get_block() {
  echo "get_block eth -> $(get_block eth)"
  echo "get_block bsc -> $(get_block bsc)"
  echo "get_block polygon -> $(get_block polygon)"
  echo "get_block polygonzk -> $(get_block polygonzk)"
  echo "get_block aminox -> $(get_block aminox)"
  echo "get_block tron -> $(get_block tron)"
  echo "get_block solana -> $(get_block solana)"
}

test_get_raw_tx() {
  # echo "get_raw_tx eth -> $(get_raw_tx eth '"0xc587f45b2bb9311f9b70dc552f962e7d8f9bd4261c077be4580a52897a80da54"')"
  echo "get_raw_tx bsc -> $(get_raw_tx bsc '"0x891481eb65e5bc52434cb002719c07a3c9b7ed810ffac38f208ea3ddff21b825"')"
  echo "get_raw_tx polygon -> $(get_raw_tx polygon '"0xe51c06c9e4c97adf0b9c77f1adf91595afd1130e29c2681510c43eecbcdf8982"')"
  echo "get_raw_tx polygonzk -> $(get_raw_tx polygonzk '"0x9ead28afb3949c13fdb4dbfcb1e05bf63d4a6d5bcc9410490421ad48d6f4d197"')"
  # echo "get_raw_tx aminox -> $(get_raw_tx aminox '"0x0fa10ac933b05c19a8c36b80125c84db69f8e4c674547052864f510a3158876c"')"
  # echo "get_raw_tx tron -> $(get_raw_tx tron '"c07224bd542478ee75a1d295af48ac7eaa1a3e603f22c7c37ae6310bde869bfb"')"
  # echo "get_raw_tx solana -> $(get_raw_tx solana '"4Ti2MeAp4r7ZyNEWVAgH4jDHGFBbWEY5fLKoAoPXUjM3QMXdUUHakWh4RqJCChsf38Szw2orFfnBbu93Cr1iQFhL"')"
}

test_get_tx_receipt() {
  echo "get_tx_receipt eth -> $(get_tx_receipt eth '"0xc587f45b2bb9311f9b70dc552f962e7d8f9bd4261c077be4580a52897a80da54"')"
  echo "get_tx_receipt bsc -> $(get_tx_receipt bsc '"0x891481eb65e5bc52434cb002719c07a3c9b7ed810ffac38f208ea3ddff21b825"')"
  echo "get_tx_receipt polygon -> $(get_tx_receipt polygon '"0xe51c06c9e4c97adf0b9c77f1adf91595afd1130e29c2681510c43eecbcdf8982"')"
  echo "get_tx_receipt polygonzk -> $(get_tx_receipt polygonzk '"0x9ead28afb3949c13fdb4dbfcb1e05bf63d4a6d5bcc9410490421ad48d6f4d197"')"
  echo "get_tx_receipt aminox -> $(get_tx_receipt aminox '"0x0fa10ac933b05c19a8c36b80125c84db69f8e4c674547052864f510a3158876c"')"
  echo "get_tx_receipt tron -> $(get_tx_receipt tron '"c07224bd542478ee75a1d295af48ac7eaa1a3e603f22c7c37ae6310bde869bfb"')"
  # echo "get_tx_receipt solana -> $(get_tx_receipt solana '"4Ti2MeAp4r7ZyNEWVAgH4jDHGFBbWEY5fLKoAoPXUjM3QMXdUUHakWh4RqJCChsf38Szw2orFfnBbu93Cr1iQFhL"')"
}

test_get_tx() {
  echo "get_tx eth -> $(get_tx eth '"0xc587f45b2bb9311f9b70dc552f962e7d8f9bd4261c077be4580a52897a80da54"')"
  echo "get_tx bsc -> $(get_tx bsc '"0x891481eb65e5bc52434cb002719c07a3c9b7ed810ffac38f208ea3ddff21b825"')"
  echo "get_tx polygon -> $(get_tx polygon '"0xe51c06c9e4c97adf0b9c77f1adf91595afd1130e29c2681510c43eecbcdf8982"')"
  echo "get_tx polygonzk -> $(get_tx polygonzk '"0x9ead28afb3949c13fdb4dbfcb1e05bf63d4a6d5bcc9410490421ad48d6f4d197"')"
  echo "get_tx aminox -> $(get_tx aminox '"0x0fa10ac933b05c19a8c36b80125c84db69f8e4c674547052864f510a3158876c"')"
  echo "get_tx tron -> $(get_tx tron '"c07224bd542478ee75a1d295af48ac7eaa1a3e603f22c7c37ae6310bde869bfb"')"
  # echo "get_tx solana -> $(get_tx solana '"4Ti2MeAp4r7ZyNEWVAgH4jDHGFBbWEY5fLKoAoPXUjM3QMXdUUHakWh4RqJCChsf38Szw2orFfnBbu93Cr1iQFhL"')"
}

test_get_balance() {
  echo "get_balance eth -> $(get_balance eth '"0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97"')"
  echo "get_balance bsc -> $(get_balance bsc '"0x8894E0a0c962CB723c1976a4421c95949bE2D4E3"')"
  echo "get_balance polygon -> $(get_balance polygon '"0x0000000000000000000000000000000000001010"')"
  echo "get_balance polygonzk -> $(get_balance polygonzk '"0x77134cbC06cB00b66F4c7e623D5fdBF6777635EC"')"
  echo "get_balance aminox -> $(get_balance aminox '"0xD401feCdC49f73be8cEF1ecaa6428f93F821fdC7"')"
  echo "get_balance tron -> $(get_balance tron '"0x2C7C9963111905D29EB8DA37D28B0F53A7BB5C28"')"
  echo "get_balance solana -> $(get_balance solana '"Fd7btgySsrjuo25CJCj7oE7VPMyezDhnx7pZkj2v69Nk"')"
}

# TODO: Handle solana
test_get_token_name() {
  echo "get_token_name eth -> $(get_token_name eth $USDT_ERC20)"
  echo "get_token_name bsc -> $(get_token_name bsc $USDT_BEP20)"
  echo "get_token_name polygon -> $(get_token_name polygon $USDT_POLYGON)"
  echo "get_token_name polygonzk -> $(get_token_name polygonzk $USDT_POLYGON_ZK)"
  echo "get_token_name aminox -> $(get_token_name aminox $USDT_AMINOX)"
  echo "get_token_name tron -> $(get_token_name tron $USDT_TRC20)"
  # echo "get_token_name solana -> $(get_token_name solana $USDT_SOLANA)"
}

test_get_token_symbol() {
  echo "get_token_symbol eth -> $(get_token_symbol eth $USDT_ERC20)"
  echo "get_token_symbol bsc -> $(get_token_symbol bsc $USDT_BEP20)"
  echo "get_token_symbol polygon -> $(get_token_symbol polygon $USDT_POLYGON)"
  echo "get_token_symbol polygonzk -> $(get_token_symbol polygonzk $USDT_POLYGON_ZK)"
  echo "get_token_symbol aminox -> $(get_token_symbol aminox $USDT_AMINOX)"
  echo "get_token_symbol tron -> $(get_token_symbol tron $USDT_TRC20)"
  # echo "get_token_symbol solana -> $(get_token_symbol solana $USDT_SOLANA)"
}

test_get_token_decimals() {
  echo "get_token_decimals eth -> $(get_token_decimals eth $USDT_ERC20)"
  echo "get_token_decimals bsc -> $(get_token_decimals bsc $USDT_BEP20)"
  echo "get_token_decimals polygon -> $(get_token_decimals polygon $USDT_POLYGON)"
  echo "get_token_decimals polygonzk -> $(get_token_decimals polygonzk $USDT_POLYGON_ZK)"
  echo "get_token_decimals aminox -> $(get_token_decimals aminox $USDT_AMINOX)"
  echo "get_token_decimals tron -> $(get_token_decimals tron $USDT_TRC20)"
  # echo "get_token_decimals solana -> $(get_token_decimals solana $USDT_SOLANA)"
}

test_get_token_balance() {
  echo "get_token_balance eth -> $(get_token_balance eth $USDT_ERC20 '"0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97"')"
  echo "get_token_balance bsc -> $(get_token_balance bsc $USDT_BEP20 '"0x8894E0a0c962CB723c1976a4421c95949bE2D4E3"')"
  echo "get_token_balance polygon -> $(get_token_balance polygon $USDT_POLYGON '"0x0000000000000000000000000000000000001010"')"
  echo "get_token_balance polygonzk -> $(get_token_balance polygonzk $USDT_POLYGON_ZK '"0x77134cbC06cB00b66F4c7e623D5fdBF6777635EC"')"
  echo "get_token_balance aminox -> $(get_token_balance aminox $USDT_AMINOX '"0xD401feCdC49f73be8cEF1ecaa6428f93F821fdC7"')"
  echo "get_token_balance tron -> $(get_token_balance tron $USDT_TRC20 '"0x2C7C9963111905D29EB8DA37D28B0F53A7BB5C28"')"
  # echo "get_token_balance solana -> $(get_token_balance solana $USDT_SOLANA '"AhhoxZDmsg2snm85vPjqzYzEYESoKfb4KmTj4HrBBNwY"')"
}

test_get_chain_health() {
  health=$( get_chain_health eth )
  health_str=$([[ $health == $HEALTHY ]] && echo healthy || echo sick or dead)
  echo "get_chain_health eth -> $health ($health_str)"

  health=$( get_chain_health bsc )
  health_str=$([[ $health == $HEALTHY ]] && echo healthy || echo sick or dead)
  echo "get_chain_health bsc -> $health ($health_str)"

  health=$( get_chain_health polygon )
  health_str=$([[ $health == $HEALTHY ]] && echo healthy || echo sick or dead)
  echo "get_chain_health polygon -> $health ($health_str)"

  health=$( get_chain_health polygonzk )
  health_str=$([[ $health == $HEALTHY ]] && echo healthy || echo sick or dead)
  echo "get_chain_health polygonzk -> $health ($health_str)"

  health=$( get_chain_health aminox )
  health_str=$([[ $health == $HEALTHY ]] && echo healthy || echo sick or dead)
  echo "get_chain_health aminox -> $health ($health_str)"

  health=$( get_chain_health tron )
  health_str=$([[ $health == $HEALTHY ]] && echo healthy || echo sick or dead)
  echo "get_chain_health tron -> $health ($health_str)"

  health=$( get_chain_health solana )
  health_str=$([[ $health == $HEALTHY ]] && echo healthy || echo sick or dead)
  echo "get_chain_health solana -> $health ($health_str)"
}

main() {
  echo "Test cases of get_rpc_url"
  test_get_rpc_url

  echo ""
  echo "Test cases of get_block_number"
  test_get_block_number

  # echo ""
  # echo "Test cases of get_block"
  # test_get_block

  echo ""
  echo "Test cases of get_raw_tx"
  test_get_raw_tx

  echo ""
  echo "Test cases of get_tx_receipt"
  test_get_tx_receipt

  echo ""
  echo "Test cases of get_tx"
  test_get_tx

  echo ""
  echo "Test cases of get_balance"
  test_get_balance

  echo ""
  echo "Test cases of get_token_name"
  test_get_token_name

  echo ""
  echo "Test cases of get_token_symbol"
  test_get_token_symbol

  echo ""
  echo "Test cases of get_token_decimals"
  test_get_token_decimals

  echo ""
  echo "Test cases of get_token_balance"
  test_get_token_balance

  echo ""
  echo "Test cases of get_chain_health"
  test_get_chain_health
}

main

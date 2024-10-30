#!/bin/bash
#
# Blockchain.

# Variables
INFURA_KEY="de6e66cb509c43e0897d062c93f15d9e"
ETH="eth"
ETH_RPC="https://mainnet.infura.io/v3/${INFURA_KEY}"
SEPOLIA="sepolia"
SEPOLIA_RPC="https://sepolia.infura.io/v3/${INFURA_KEY}"

BSC="bsc"
BSC_RPC="https://bsc-dataseed.binance.org"
BSC_TESTNET="bsctestnet"
BSC_TESTNET_RPC="https://data-seed-prebsc-1-s1.binance.org:8545"

PLY="polygon"
PLY_RPC="https://polygon-rpc.com"
PLY_TESTNET="polygontestnet"
PLY_TESTNET_RPC="https://rpc-amoy.polygon.technology"

AMINOX="aminox"
AMINOX_RPC="https://aminox.node.alphacarbon.network"
AMINOX_TESTNET="aminoxtestnet"
AMINOX_TESTNET_RPC="https://aminoxtestnet.node.alphacarbon.network"

TRON="tron"
TRON_RPC="https://api.trongrid.io/jsonrpc"
SHASTA="shasta"
SHASTA_RPC="https://api.shasta.trongrid.io/jsonrpc"

SOLANA="solana"
SOLANA_RPC="https://api.mainnet-beta.solana.com"

NODES="\
${ETH} \
${SEPOLIA} \
${BSC} \
${BSC_TESTNET} \
${PLY} \
${PLY_TESTNET} \
${AMINOX} \
${AMINOX_TESTNET} \
${TRON} \
${SHASTA} \
${SOLANA} \
"

USDT_ERC20="0xdAC17F958D2ee523a2206206994597C13D831ec7"
USDT_BEP20="0x55d398326f99059fF775485246999027B3197955"
USDT_POLYGON="0xc2132D05D31c914a87C6611C10748AEb04B58e8F"
USDT_AMINOX="0xFFfffffF8d2EE523a2206206994597c13D831EC7"
USDT_TRC20="0xa614f803B6FD780986A42c78Ec9c7f77e6DeD13C"
USDT_SOLANA="Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB"

# Keccak-256 encoded
# name()
NAME_FUNC="0x06fdde03"
# symbol()
SYMBOL_FUNC="0x95d89b41"
# decimals()
DECIMALS_FUNC="0x313ce567"
# balanceOf(address)
BALANCEOF_FUNC="0x70a08231"

#######################################
# Call Ethereum JSON-RPC.
# Arguments:
#   RPC URL of the node.
#   Name of the method.
#   Parameters.
# Outputs:
#   Result from response.
#######################################
call_rpc() {
  if [ "$#" -lt 2 ]; then
    return
  fi
  local rpc_url="$1"
  local method="$2"
  # Note: cannot form params_array when sourcing from other file
  # local params_array=( "${@:3}" )
  # local params=$(IFS=","; printf '%s' "$params_array"; unset IFS)
  # local params=$( printf "%s" "$params_array" | jq -sRc 'split(" ")' )
  local params=$( printf "%s" "${@:3}" | jq -sc )
  local data=$(
    printf '{"jsonrpc":"2.0","method":"%s","params":%s,"id":1}' \
      "$method" \
      "$params"
  )

  result=$(
    curl --silent \
      -X POST \
      -H 'Content-Type: application/json' \
      -d $data \
      $rpc_url \
      | jq -r '.result'
  )

  [ ! -z "$result" ] && echo "$result"
}

#######################################
# Get RPC URL.
# Arguments:
#   Name of the chain or RPC URL of the node.
# Outputs:
#   RPC URL.
#######################################
get_rpc_url() {
  if [ "$#" != 1 ]; then
    return
  fi

  local rpc_url

  if [[ "$1" == "$ETH" ]]; then
    rpc_url="$ETH_RPC"
  elif [[ "$1" == "$SEPOLIA" ]]; then
    rpc_url="$SEPOLIA_RPC"
  elif [[ "$1" == "$AMINOX" ]]; then
    rpc_url="$AMINOX_RPC"
  elif [[ "$1" == "$AMINOX_TESTNET" ]]; then
    rpc_url="$AMINOX_TESTNET_RPC"
  elif [[ "$1" == "$BSC" ]]; then
    rpc_url="$BSC_RPC"
  elif [[ "$1" == "$BSC_TESTNET" ]]; then
    rpc_url="$BSC_TESTNET_RPC"
  elif [[ "$1" == "$PLY" ]]; then
    rpc_url="$PLY_RPC"
  elif [[ "$1" == "$PLY_TESTNET" ]]; then
    rpc_url="$PLY_TESTNET_RPC"
  elif [[ "$1" == "$TRON" ]]; then
    rpc_url="$TRON_RPC"
  elif [[ "$1" == "$SHASTA" ]]; then
    rpc_url="$SHASTA_RPC"
  elif [[ "$1" == "$SOLANA" ]]; then
    rpc_url="$SOLANA_RPC"
  else
    rpc_url="$1"
  fi

  echo $rpc_url
}

#######################################
# Get block number.
# Arguments:
#   Name of the chain or RPC URL of the node.
# Outputs:
#   Block number.
#######################################
get_block_number() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url>"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 1 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"

  # https://github.com/foundry-rs/foundry is required for cast
  # block_num=$(
  #   cast block-number --rpc-url $rpc_url
  # )

  if [[ $rpc_url == "$SOLANA_RPC" ]]; then
    block_num=$( call_rpc $rpc_url getSlot $tx )
  else
    block_num=$( call_rpc $rpc_url eth_blockNumber )
  fi

  # block number in hexadecimal
  # [ ! -z "$block_num" ] && echo $block_num
  # block number in decimal
  [ ! -z "$block_num" ] && echo $((block_num))
}

#######################################
# Get block.
# Arguments:
#   Name of the chain or RPC URL of the node.
#   Number of the block (empty for latest block).
# Outputs:
#   Block with the specified number or latest.
#######################################
get_block() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url> [block_num]"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 1 ] && [ "$#" != 2 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"
  local block_num="$2"

  [ ! -z "$block_num" ] && \
    block=$( call_rpc $rpc_url eth_getBlockByNumber "$block_num" true ) || \
    block=$( call_rpc $rpc_url eth_getBlockByNumber '"latest"' true )

  [ ! -z "$block" ] && echo $block
}

#######################################
# Get raw transaction.
# Arguments:
#   Name of the chain or RPC URL of the node.
#   Hash of the transaction.
# Outputs:
#   Raw transaction.
#######################################
get_raw_tx() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url> <tx_hash>"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 2 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"
  local tx_hash="$2"

  # eth_getRawTransactionByHash is not supported by Infura
  raw_tx=$( call_rpc $rpc_url eth_getRawTransactionByHash $tx_hash )

  [ ! -z "$raw_tx" ] && echo $raw_tx
}

#######################################
# Get transaction receipt.
# Arguments:
#   Name of the chain or RPC URL of the node.
#   Hash of the transaction.
# Outputs:
#   Transaction receipt.
#######################################
get_tx_receipt() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url> <tx_hash>"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 2 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"
  local tx_hash="$2"

  tx_receipt=$( call_rpc $rpc_url eth_getTransactionReceipt $tx_hash )

  [ ! -z "$tx_receipt" ] && echo $tx_receipt
}

#######################################
# Get balance.
# Arguments:
#   Name of the chain or RPC URL of the node.
#   Address of the account.
# Outputs:
#   Balance (in hex) of the account.
#######################################
get_balance() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url> <address>"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 2 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"
  local address="$2"

  if [[ $rpc_url == "$SOLANA_RPC" ]]; then
    balance=$( call_rpc $rpc_url getBalance $address | jq -r '.value' )
  else
    balance=$( call_rpc $rpc_url eth_getBalance $address '"latest"' )
  fi

  [ ! -z "$balance" ] && echo $balance
}

#######################################
# Get name of the token.
# Arguments:
#   Name of the chain or RPC URL of the node.
#   Address of the token contract.
# Outputs:
#   Name of the token.
#######################################
get_token_name() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url> <address>"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 2 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"
  local address="$2"
  local tx=$(
    printf '{"to":"%s","data":"%s"}' \
      "$address" \
      "$NAME_FUNC"
  )

  name=$( call_rpc $rpc_url eth_call $tx '"latest"' )

  [ ! -z "$name" ] && echo -n $name | xxd -r -p
}

#######################################
# Get symbol of the token.
# Arguments:
#   Name of the chain or RPC URL of the node.
#   Address of the token contract.
# Outputs:
#   Symbol of the token.
#######################################
get_token_symbol() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url> <address>"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 2 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"
  local address="$2"
  local tx=$(
    printf '{"to":"%s","data":"%s"}' \
      "$address" \
      "$SYMBOL_FUNC"
  )

  symbol=$( call_rpc $rpc_url eth_call $tx '"latest"' )

  [ ! -z "$symbol" ] && echo -n $symbol | xxd -r -p
}

#######################################
# Get decimals of the token.
# Arguments:
#   Name of the chain or RPC URL of the node.
#   Address of the token contract.
# Outputs:
#   Decimals of the token.
#######################################
get_token_decimals() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url> <address>"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 2 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"
  local address="$2"
  if [[ $rpc_url == "$SOLANA_RPC" ]]; then
    local tx=$(
      printf '"%s"' \
        "$address"
    )
  else
    local tx=$(
      printf '{"to":"%s","data":"%s"}' \
        "$address" \
        "$DECIMALS_FUNC"
    )
  fi

  if [[ $rpc_url == "$SOLANA_RPC" ]]; then
    decimals=$( call_rpc $rpc_url getTokenSupply $tx | jq -r '.value.decimals' )
  else
    decimals=$( call_rpc $rpc_url eth_call $tx '"latest"' )
  fi

  [ ! -z "$decimals" ] && echo $((decimals))
}

#######################################
# Get token balance.
# Arguments:
#   Name of the chain or RPC URL of the node.
#   Address of the token contract.
#   Address of the account.
# Outputs:
#   Token balance (in hex) of the account.
#######################################
get_token_balance() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url> <token_addr> <account_addr>"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 3 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"
  local token_addr="$2"
  local account_addr="$3"
  local account_hex=$( echo $account_addr | sed -e "s/^\"//;s/\"$//" | sed -e "s/^0x//" )
  
  if [[ $rpc_url == "$SOLANA_RPC" ]]; then
    local tx=$(
      printf '{"mint":"%s"}' \
        "$token_addr"
    )
  else
    local tx=$(
      printf '{"to":"%s","data":"%s%024d%s"}' \
      "$token_addr" \
      "$BALANCEOF_FUNC" \
      "0" \
      "$account_hex"
    )
  fi

  if [[ $rpc_url == "$SOLANA_RPC" ]]; then
    balance=$( call_rpc $rpc_url getTokenAccountsByOwner $account_addr $tx '{"encoding":"jsonParsed"}' | jq -r '.value[0].account.data.parsed.info.tokenAmount.amount' )
  else
    balance=$( call_rpc $rpc_url eth_call $tx '"latest"' )
  fi

  [ ! -z "$balance" ] && echo $balance
}

#######################################
# Get health of blockchain by checking ts.
# Arguments:
#   Name of the chain or RPC URL of the node.
# Outputs:
#   0 if is healthy, 1 if is sick, 2 if is dead.
#######################################
readonly HEALTHY=0
readonly SICK=1
readonly DEAD=2
# Tolerance in seconds
readonly TOLERANCE=60

get_chain_health() {
  show_usage() {
    echo "Usage:"
    echo "  $@ <node or rpc_url>"
    echo ""
    echo "Nodes:"
    for NODE in ${NODES}; do
      echo "  ${NODE}"
    done
    echo ""
  }

  if [ "$#" != 1 ]; then
    # show_usage "$@"
    # echo "$funcstack"
    show_usage "$0"
    return
  fi

  local rpc_url="$( get_rpc_url $1 )"

  if [[ $rpc_url == "$SOLANA_RPC" ]]; then
    block_num=$( call_rpc $rpc_url getSlot )
    block_ts=$( call_rpc $rpc_url getBlockTime $block_num )
  else
    block=$( call_rpc $rpc_url eth_getBlockByNumber '"latest"' true )
    [ -z "$block" ] && echo $DEAD
    block_ts=$( echo $block | jq -r '.timestamp' )
  fi

  now_ts=$( date +%s )

  if [ $(($now_ts - $block_ts)) -gt $TOLERANCE ]; then
    echo $SICK
  else
    echo $HEALTHY
  fi
}

#######################################
# Showcase of the functions.
# Arguments:
#   None
# Outputs:
#   Showcase result.
#######################################
blockchain_showcase () {
  echo "get_rpc_url"
  get_rpc_url bsctestnet
  echo "get_block_number"
  get_block_number bsctestnet
  echo "get_block latest"
  get_block bsctestnet

  # Case sensitive for param number on Polygon Mainnet
  # Ex. block 46011246 on Polygon Mainnet
  # Confirmed
  # get_block polygon '"0x2BE136E"'
  # Forked?
  # get_block polygon '"0x2be136e"'

  echo "get_raw_tx"
  get_raw_tx bsctestnet '"0xd7065c84e3c1e4b514054d6bf49451fb4ff956b9062965ec656a7ee75f6d33b1"'
  echo "get_tx_receipt"
  get_tx_receipt bsctestnet '"0xd7065c84e3c1e4b514054d6bf49451fb4ff956b9062965ec656a7ee75f6d33b1"'

  echo "get_balance"
  get_balance bsctestnet '"0x980A75eCd1309eA12fa2ED87A8744fBfc9b863D5"'

  echo "get_token_name"
  get_token_name eth $USDT_ERC20
  echo ""
  echo "get_token_symbol"
  get_token_symbol eth $USDT_ERC20
  echo ""
  echo "get_token_decimals"
  get_token_decimals eth $USDT_ERC20
  get_token_decimals solana $USDT_SOLANA
  echo "get_token_balance"
  get_token_balance eth $USDT_ERC20 '"0x36928500Bc1dCd7af6a2B4008875CC336b927D57"'

  echo "get_chain_health"
  health=$( get_chain_health eth )
  echo -n "eth is "
  [[ $health == $HEALTHY ]] && echo "healthy" || echo "sick or dead"
  health=$( get_chain_health bsc )
  echo -n "bsc is "
  [[ $health == $HEALTHY ]] && echo "healthy" || echo "sick or dead"
  health=$( get_chain_health aminox )
  echo -n "aminox is "
  [[ $health == $HEALTHY ]] && echo "healthy" || echo "sick or dead"
  health=$( get_chain_health tron )
  echo -n "tron is "
  [[ $health == $HEALTHY ]] && echo "healthy" || echo "sick or dead"
}

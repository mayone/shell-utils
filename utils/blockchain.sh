#!/bin/bash
#
# Blockchain.

# Variables
ETH="eth"
ETH_RPC="https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"

AMINOX="aminox"
AMINOX_RPC="https://aminox.node.alphacarbon.network/"
AMINOX_TESTNET="aminoxtestnet"
AMINOX_TESTNET_RPC="https://aminoxtestnet.node.alphacarbon.network/"

BSC="bsc"
BSC_RPC="https://bsc-dataseed.binance.org/"
BSC_TESTNET="bsctestnet"
BSC_TESTNET_RPC="https://data-seed-prebsc-1-s1.binance.org:8545/"

PLY="polygon"
PLY_RPC="https://polygon-rpc.com/"
PLY_TESTNET="polygontestnet"
PLY_TESTNET_RPC="https://rpc-mumbai.maticvigil.com/"

# TronGrid API URL
# Reference: https://developers.tron.network/reference/background
TRON_API="https://api.trongrid.io/"
SHASTA_API="https://api.shasta.trongrid.io/"

NODES="\
${ETH} \
${AMINOX} \
${AMINOX_TESTNET} \
${BSC} \
${BSC_TESTNET} \
${PLY} \
${PLY_TESTNET} \
"

USDT_ERC20="0xdAC17F958D2ee523a2206206994597C13D831ec7"
USDT_BEP20="0x55d398326f99059fF775485246999027B3197955"
# USDT_TRC20="TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t"

# Keccak-256 encoded
# decimals()
DECIMALS_FUNC="0x313ce567"
# name()
NAME_FUNC="0x06fdde03"
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
  local params_array=("${@:3}")
  # local params=$(IFS=","; printf '%s' "$params_array"; unset IFS)
  # local params=$( printf "%s" "$params_array" | jq -sRc 'split(" ")' )
  local params=$( printf "%s" "$params_array" | jq -sc )
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
  # block_number=$(
  #   cast block-number --rpc-url $rpc_url
  # )

  block_number=$( call_rpc $rpc_url eth_blockNumber )

  # block number in hexadecimal
  # [ ! -z "$block_number" ] && echo $block_number
  # block number in decimal
  [ ! -z "$block_number" ] && echo $((block_number))
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

  balance=$( call_rpc $rpc_url eth_getBalance $address '"latest"' )

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
  local tx=$(
    printf '{"to":"%s","data":"%s"}' \
      "$address" \
      "$DECIMALS_FUNC"
  )

  decimals=$( call_rpc $rpc_url eth_call $tx '"latest"' )

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
  local tx=$(
    printf '{"to":"%s","data":"%s%024d%s"}' \
      "$token_addr" \
      "$BALANCEOF_FUNC" \
      "0" \
      "$account_hex"
  )

  balance=$( call_rpc $rpc_url eth_call $tx '"latest"' )

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

  block=$( call_rpc $rpc_url eth_getBlockByNumber '"latest"' true )

  [ -z "$block" ] && echo $DEAD

  block_ts=$( echo $block | jq -r '.timestamp' )
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
  echo "get_token_decimals"
  get_token_decimals eth $USDT_ERC20
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
}

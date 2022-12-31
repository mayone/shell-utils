#!/bin/bash
#
# Blockchain.

# Variables
AMINOX="aminox"
AMINOX_RPC="https://aminox.node.alphacarbon.network/"
AMINOX_TESTNET="aminoxtestnet"
AMINOX_TESTNET_RPC="https://aminoxtestnet.node.alphacarbon.network/"

BSC="bsc"
BSC_RPC="https://bsc-dataseed.binance.org/"
BSC_TESTNET="bsctestnet"
BSC_TESTNET_RPC="https://data-seed-prebsc-1-s1.binance.org:8545/"

NODES="\
${AMINOX} \
${AMINOX_TESTNET} \
${BSC} \
${BSC_TESTNET} \
"

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
  local params=$( printf "%s" "$params_array" | jq -sRc 'split(" ")' )
  local data=$( printf '{"jsonrpc":"2.0","method":"%s","params":%s,"id":1}' "$method" "$params" )

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

  if [[ "$1" == "$AMINOX" ]]; then
    rpc_url="$AMINOX_RPC"
  elif [[ "$1" == "$AMINOX_TESTNET" ]]; then
    rpc_url="$AMINOX_TESTNET_RPC"
   elif [[ "$1" == "$BSC" ]]; then
    rpc_url="$BSC_RPC"
   elif [[ "$1" == "$BSC_TESTNET" ]]; then
    rpc_url="$BSC_TESTNET_RPC"
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
# Get raw transaction.
# Arguments:
#   Name of the chain or RPC URL of the node.
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
# Showcase of the functions.
# Arguments:
#   None
# Outputs:
#   Showcase result.
#######################################
blockchain_showcase () {
  get_rpc_url bsctestnet
  get_block_number bsctestnet
  get_raw_tx bsctestnet 0xd7065c84e3c1e4b514054d6bf49451fb4ff956b9062965ec656a7ee75f6d33b1
}

# TODO: Implement other function (these are on bsctestnet)
# call_rpc $rpc_url "eth_getTransactionReceipt" "0xd7065c84e3c1e4b514054d6bf49451fb4ff956b9062965ec656a7ee75f6d33b1"
# call_rpc $rpc_url "eth_getBalance" "0x980A75eCd1309eA12fa2ED87A8744fBfc9b863D5" "latest"
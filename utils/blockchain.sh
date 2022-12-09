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
#   RPC URL of the node.
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

  local rpc_url="$(get_rpc_url $1)"

  # https://github.com/foundry-rs/foundry is required for cast
  # cast block-number --rpc-url $rpc_url

  block_number=$(
    curl --silent \
      -X POST \
      -H 'Content-Type: application/json' \
      -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
      $rpc_url \
      | jq -r '.result'
  )
  # block number in hexadecimal
  # [ ! -z "$block_number" ] && echo $block_number
  # block number in decimal
  [ ! -z "$block_number" ] && echo $((block_number))
}

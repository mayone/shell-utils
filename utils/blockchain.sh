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

  if [[ "$1" == "$AMINOX" ]]; then
    cast block-number --rpc-url "$AMINOX_RPC"
  elif [[ "$1" == "$AMINOX_TESTNET" ]]; then
    cast block-number --rpc-url "$AMINOX_TESTNET_RPC"
   elif [[ "$1" == "$BSC" ]]; then
    cast block-number --rpc-url "$BSC_RPC"
   elif [[ "$1" == "$BSC_TESTNET" ]]; then
    cast block-number --rpc-url "$BSC_TESTNET_RPC"
  else
    cast block-number --rpc-url "$1"
  fi
}

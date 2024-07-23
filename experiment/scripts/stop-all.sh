#!/bin/bash

# Verifique se o total de hosts está especificado
if [ $# -lt 1 ]; then
  echo "Uso: $0 totalNodes"
  exit 1
fi

totalNodes="$1"

SCRIPT_DIR=$(dirname $(readlink -f "$0"))


for i in $(seq 1 $totalNodes); do
    # NODE_IDX=$((i - 1))  # Adjust for zero-based indexing

    node="node$i"

    SSH_COMMAND="ssh -o StrictHostKeyChecking=no $node"

    echo "Starting (node $node)..."

    COMMAND="$SSH_COMMAND killall cometbft"

    # echo $COMMAND
    
    $COMMAND
done
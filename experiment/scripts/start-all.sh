#!/bin/bash

# Verifique se o total de hosts está especificado
if [ $# -lt 1 ]; then
  echo "Uso: $0 totalNodes"
  exit 1
fi

totalNodes="$1"

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
BINARY="$SCRIPT_DIR/cometbft"

DIR=$(dirname $(readlink -f "$0"))
DIR_HOME_COMETBFT="$DIR/../.cometbft"

for i in $(seq 1 $totalNodes); do
    # NODE_IDX=$((i - 1))  # Adjust for zero-based indexing

    node="node$i"

    SSH_COMMAND="ssh -o StrictHostKeyChecking=no $node"

    echo "Starting (node $node)..."

    COMMAND="$SSH_COMMAND -n -f nohup $BINARY node --proxy_app noop --home $DIR_HOME_COMETBFT > log.log 2> log.err < /dev/null &"

    # echo $COMMAND
    
    $COMMAND
done
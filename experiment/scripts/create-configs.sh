
# Verifique se o total de hosts está especificado
if [ $# -lt 1 ]; then
  echo "Uso: $0 totalNodes"
  exit 1
fi

totalNodes="$1"

DIR=$(dirname $(readlink -f "$0"))
DIR="$DIR/.."
BINARY="$DIR/cometbft"


rm -r $DIR/node-configs

# configure path comebft

$BINARY testnet --config $DIR/config/config-template.toml --o $DIR/node-configs  --starting-ip-address 10.10.1.2 --v $totalNodes

# Copy to remote

for i in $(seq 1 $totalNodes); do

  NODE="node$i"

  echo ""
  echo "Copy $NODE files"

  NODEIDX=$((i - 1))

  NODE_DIR_CONFIG="$DIR/node-configs/node$NODEIDX/"

  echo "Delete old files from node $NODE"
  ssh -o StrictHostKeyChecking=no $NODE rm -r $DIR/.cometbft


  echo "Copy config files to node $NODE"
  COMMAND="scp -r -o StrictHostKeyChecking=no $NODE_DIR_CONFIG $NODE:$DIR/.cometbft"

  $COMMAND
  # echo $COMMAND

done
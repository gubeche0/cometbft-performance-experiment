
# Verifique se o total de hosts está especificado
if [ $# -lt 1 ]; then
  echo "Uso: $0 totalNodes"
  exit 1
fi

totalNodes="$1"

DIR=$(dirname $(readlink -f "$0"))
DIR="$DIR/.."


for i in $(seq 1 $totalNodes); do

  NODE="node$i"

  echo "Copy log from $NODE"

  mkdir -p $DIR/logsresults
  COMMAND="scp -r -o StrictHostKeyChecking=no $NODE:~/log-client.txt $DIR/logsresults/log$i.txt"

  $COMMAND

done
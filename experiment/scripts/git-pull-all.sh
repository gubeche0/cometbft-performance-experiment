
# Verifique se o total de hosts está especificado
if [ $# -lt 1 ]; then
  echo "Uso: $0 totalNodes"
  exit 1
fi

totalNodes="$1"

DIR=$(dirname $(readlink -f "$0"))


for i in $(seq 1 $totalNodes); do

  NODE="node$i"

  echo "Copy ssh files and git pull for $NODE"

  ssh -o StrictHostKeyChecking=no $NODE $DIR/configure-ssh.sh

done
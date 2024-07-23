
# Verifique se o total de hosts está especificado
if [ $# -lt 3 ]; then
  echo "Uso: $0 totalNodes totalTx totalConcurrentTx"
  exit 1
fi

totalNodes="$1"
totalTx="$2"
totalConcurrentTx="$3"

DIR=$(dirname $(readlink -f "$0"))
DIR="$DIR/.."


rm ./hosts2.txt
for i in $(seq 1 $totalNodes); do

  NODE="node$i"

  # echo "Start client $NODE"

  # COMMAND="ssh -o StrictHostKeyChecking=no $NODE -n -f nohup $DIR/client/build/client_linux_arm64 --totalTx $totalTx --totalConcurrentTx $totalConcurrentTx --output log-client.txt > log-client.log 2> log-client.log< /dev/null &"

  # $COMMAND

  echo $NODE >> hosts2.txt

done

parallel-ssh -i -h hosts2.txt -p 256 -t 0 -- $DIR/client/build/client_linux_arm64 --totalTx $totalTx --totalConcurrentTx $totalConcurrentTx --output log-client.txt
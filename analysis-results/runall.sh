#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Uso: $0 logresults-sufix-name totalNodes\n Exemplo: $0 2-30-50 32"
  exit 1
fi

logresultsName="$1"
totalNodes="$2"

python3 Create-blocks-file.py data/logsresults-$logresultsName/log10.txt data-out/blocks-$logresultsName.csv
python3 create-transactions-file.py data/logsresults-$logresultsName data-out/transactions-$logresultsName.csv $totalNodes

python3 grafico-blocks.py data-out/blocks-$logresultsName.csv
python3 grafico-transactions-latency.py data-out/transactions-$logresultsName.csv
python3 grafico-transactions-per-block.py data-out/blocks-$logresultsName.csv
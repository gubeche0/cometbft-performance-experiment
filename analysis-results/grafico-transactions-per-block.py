import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

import argparse
from pathlib import Path
parser = argparse.ArgumentParser()
parser.add_argument("input_file", type=Path)

p = parser.parse_args()

if (not p.input_file.exists()):
    print("File not found")
    exit()

file_path = p.input_file
file = file_path.stem

df = pd.read_csv(file_path, sep=';', names=[
    'type', 'block', 'totalTxs', 'DataBloco', 'localDate'
])

# Dados de exemplo
# np.random.seed(0)
# data = np.random.normal(loc=1000, scale=200, size=1000)
data = df["totalTxs"]
# data = df["totalTxs"]/df["totalTxs"].sum()
# print(data)
# Histograma
counts, bins, patches = plt.hist(data, bins=10, color='purple', alpha=0.5, weights=np.ones(len(data)) / len(data))

print(counts, bins)
# Linha acumulada
cdf = np.cumsum(counts)
cdf = cdf / cdf[-1]  # Normaliza para que o último valor seja 1

# # Plotar a linha acumulada
plt.plot(bins[:-1], cdf, color='green', lw=3)

# Configurações do gráfico
plt.xlabel('Transactions per block', fontsize=20)
plt.ylabel('')
plt.ylim(0, 1)
plt.grid(True)
plt.savefig(f'transactions-per-block-{file}.png')
plt.show()
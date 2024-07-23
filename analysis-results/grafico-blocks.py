import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

def calcular_latencia(df, coluna_tempo):
    df['latencia'] = (df[coluna_tempo] - df[coluna_tempo].shift(1)).dt.total_seconds()
    # df['latencia'] = df['latencia'].fillna(df['latencia'].mean())
    # df['latencia'] =  df['latencia'].dropna() # not working?
    df.dropna(subset=['latencia'], inplace = True)
    return df

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


# Convertendo a coluna de tempo para datetime
df['DataBloco'] = pd.to_datetime(df['DataBloco'])

# Calculando a latência de bloco
df = calcular_latencia(df, 'DataBloco')

# Dados de exemplo
# np.random.seed(0)
# data = np.random.normal(loc=1000, scale=200, size=1000)
data = df["latencia"]
# data = df["totalTxs"]/df["totalTxs"].sum()
# print(data)
# Histograma
counts, bins, patches = plt.hist(data, bins=10, color='purple', alpha=0.5, range=(0, data.max() + 1), weights=np.ones(len(data)) / len(data))

print(counts, bins)
# Linha acumulada
cdf = np.cumsum(counts)
cdf = cdf / cdf[-1]  # Normaliza para que o último valor seja 1

# # Plotar a linha acumulada
plt.plot(bins[:-1], cdf, color='green', lw=3)

# Configurações do gráfico
plt.xlabel('Block latency (s)', fontsize=20)
plt.ylabel('')
plt.ylim(0, 1)
plt.grid(True)
plt.savefig(f'block-latency-{file}.png')
plt.show()

import argparse
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("input_file", type=Path)
parser.add_argument("out_file", type=Path)

p = parser.parse_args()

if (not p.input_file.exists()):
    print("File not found")
    exit()

file = p.input_file
fileOut = open(p.out_file, "w")

# file = "data/logsresults-2-30-50/log1.txt"
# fileOut = "data-out/blocks-2-30-50.csv"

# fileOut = open(fileOut, "w")

with open(file, "r") as f:
    # lines = f.readlines()
    for line in f:
        if (line.startswith("NewBlock")):
            fileOut.write(line)



fileOut.close()

import argparse
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("input_folder", type=Path)
parser.add_argument("out_file", type=Path)
parser.add_argument("total_nodes", type=int)

p = parser.parse_args()

if (not p.input_folder.exists()):
    print("File not found")
    exit()

folderPath = str(p.input_folder) + "/"
fileOut = open(p.out_file, "w")

totalNodes = p.total_nodes
totalErrors = 0

for i in range(1, totalNodes+1):
    file = folderPath + "log" + str(i) + ".txt"
    errorInFile = False
    print("Reading file: " + file)
    with open(file, "r") as f:
        for line in f:
            if (not line.startswith("transaction")):
                continue
            
            fileOut.write(f"node{i};{line}")
            if (not line.startswith("transaction;200 OK")):
                errorInFile = True
                totalErrors += 1

    if errorInFile:
        print("Error in file: " + file)
if totalErrors > 0:
    print("Total errors: " + str(totalErrors))



fileOut.close()
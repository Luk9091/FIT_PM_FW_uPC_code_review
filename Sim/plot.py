import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

args = sys.argv[1:]
if len(args) < 1:
    print("Invalid param!")
    print("Expected: python plot.py [plot file]")
    sys.exit(1)

DIFF = False
if "--diff" in args:
    DIFF = True
    args.remove("--diff")


df = []
if DIFF:
    plt.subplot(2, 1, 1)
for i in range(len(args)):
    df.append(pd.read_csv(args[i]))

    index = df[i]["index"].values
    values = df[i]["R16:R17"].values
    plt.scatter(index, values)
plt.grid(True)


if DIFF:
    plt.subplot(2, 1, 2)
    index = df[0]["index"].values
    values = np.array(df[1]["R16:R17"].values) - np.array(df[0]["R16:R17"].values)
    plt.scatter(index, values)
plt.grid(True)

plt.show()

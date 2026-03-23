import sys

index = sys.argv[1]
if index.startswith("0x"):
    index = int(index[2:], base = 16)
else:
    index = int(index)

print(f"{index} -> {index.to_bytes()}")

import binascii
from pathlib import Path
import sys

args = sys.argv[1:]
if len(args) < 1:
    print("Usage: python getAddr.py [search str]")
    exit(1)

# Ścieżka do przesłanego pliku
hex_file_path = Path("flash.hex")

# Konwersja Intel HEX do binarnego
bin_data = bytearray()
with open(hex_file_path, "r") as hex_file:
    hex_data = hex_file.readlines()

# Przetwarzanie linii HEX i zapis do pliku binarnego
for line in hex_data:
    if line.startswith(":"):
        byte_count = int(line[1:3], 16)
        address = int(line[3:7], 16)
        record_type = int(line[7:9], 16)

        # Jeśli to rekord danych (typ 00)
        if record_type == 0:
            data = binascii.unhexlify(line[9:9 + byte_count * 2])
            bin_data.extend(data)

# Szukany napis
search_text = args[0].encode("utf-8")

# Szukanie napisu w danych binarnych
positions = []
index = bin_data.find(search_text)
while index != -1:
    positions.append(index)
    index = bin_data.find(search_text, index + 1)

# Zwrócenie pozycji napisu w pliku
print(f"0x{positions[0]:X}")

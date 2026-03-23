import sys
import binascii
from pathlib import Path

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


index = sys.argv[1]
if index.startswith("0x"):
    index = int(index[2:], base = 16)
else:
    index = int(index)



try:
    print(f"Msg: %{bin_data[index:index+64].decode(errors="replace")}")
    for i in range(-2, 10, 1):
        print(f"Byte {i}: 0x{bin_data[index + i]:02X} -> char: {bin_data[index + i].to_bytes().decode(errors="replace")}")
except IndexError:
    print("Nie ma takiego adresu")

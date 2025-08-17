# Read from a file containing one 32-bit binary instruction per line
with open('hex.txt', 'r') as f:
    lines = [line.strip() for line in f if line.strip()]

mem_bytes = []
for instr in lines:
    if len(instr) != 32:  # Basic validation
        raise ValueError(f"Invalid instruction length: {instr}")
    # Split into bytes (8 bits per byte): big-endian (MSB first)
    mem_bytes.extend([instr[0:8], instr[8:16], instr[16:24], instr[24:32]])

# Write to output (e.g., instructions.mem)
with open('instructions.mem', 'w') as f:
    for byte in mem_bytes:
        f.write(byte + '\n')

print("Done! Wrote bytes to instructions.mem.")

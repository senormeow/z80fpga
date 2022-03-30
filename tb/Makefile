#Assemble and generate memfile for rom

rom.mem: rom.bin
	cat rom.bin | hexdump -v -e '/1 "%02X\n"' > rom.mem

rom.bin rom.lst: rom.asm
	z80asm -o rom.bin -lrom.lst rom.asm
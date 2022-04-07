# Experimental Z80 Test System
 Source files for building a simple z80 based system that can be synthesized to an fpga. Goals include:

 + Use iVerilog and and myhdl to test system
 + Implement UART for communication
 + Synthesize on Xilinx Baysys2 and Papilio One
 + Generate rom files using z80 assembly

Z80 core is from https://github.com/lipro/tv80

Full system is in `rtl/z80system.v`

FPGA implementation in `ise/top.v`

Compile assembly using `make` in `tb` folder

Run `z80_bench.py` in `tb` folder to test system and produce GTKWave output

## Licence

Copyright © 2022, Evan Salazar
All files copyright under Creative Commons Attribution 4.0 (cc-by-4.0) unless otherwise stated

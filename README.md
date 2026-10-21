# Simple Processor Design

An educational 8-bit accumulator processor with a two-state fetch/execute controller. The instruction word has a four-bit opcode and four-bit immediate or address. The address space is 16 words. `rtl/processor.vhd` describes the synchronous controller and ALU; `model.py` is an executable reference model with tests.

| Opcode | Mnemonic | Effect |
| --- | --- | --- |
| 0 | NOP | Next instruction |
| 1 | LDI n | A = n |
| 2 | ADD n | A = (A + n) mod 256 |
| 3 | SUB n | A = (A - n) mod 256 |
| 4 | AND n | A = A and n |
| 5 | OR n | A = A or n |
| 6 | XOR n | A = A xor n |
| 7 | JMP n | PC = n |
| 8 | JZ n | PC = n if A = 0 |
| 9 | OUT | Output = A, output_valid pulse |
| F | HALT | Stop fetching |

## Try it

```sh
python model.py 12 22 90 F0
python -m unittest discover -s tests -v
```

The example loads 2, adds 2, emits 4, then halts. The VHDL has a testbench in `rtl/tb_processor.vhd` for a VHDL-2008 simulator:

```sh
ghdl -a --std=08 rtl/processor.vhd rtl/tb_processor.vhd
ghdl -e --std=08 tb_processor
ghdl -r --std=08 tb_processor --assert-level=error
```

No FPGA pin assignment or physical board validation is included. Quartus II synthesis depends on the target device and project settings.


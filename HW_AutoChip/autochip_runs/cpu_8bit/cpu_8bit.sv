Let us make a brand new microprocessor design together.
We're severely constrained on space and I/O. We have to fit in
1000 standard cells of an ASIC, so I think we will need to restrict
ourselves to an accumulator based 8-bit architecture with no
multi-byte instructions. Given this, how do you think we should begin?

To make the design concrete for AutoChip, use the following architecture.

Requirements:

- 8-bit accumulator-based architecture
- Every instruction is exactly one byte (8 bits)
- No multi-byte instructions
- 4-bit program counter, allowing 16 instruction locations
- One instruction executes on each rising edge of the clock when enable is high
- Active-low reset
- Keep the implementation simple and synthesizable

Instruction format:

    instruction[7:4] = 4-bit opcode
    instruction[3:0] = 4-bit operand

ISA:

    4'h0 : NOP
    4'h1 : LDI imm4
    4'h2 : ADD imm4
    4'h3 : SUB imm4
    4'h4 : AND imm4
    4'h5 : OR imm4
    4'h6 : XOR imm4
    4'h7 : SHL
    4'h8 : SHR
    4'h9 : INC
    4'hA : DEC
    4'hB : IN
    4'hC : OUT
    4'hD : JMP addr4
    4'hE : JZ addr4
    4'hF : HALT

For all instructions except JMP, JZ when taken, and HALT,
the program counter should advance by one.

When enable is low, the CPU should hold its state.

out_valid should normally be 0 and pulse high only when an OUT instruction executes.

When halted is high, the processor should stop changing state.

On reset:

    pc = 0
    accumulator = 0
    out_port = 0
    out_valid = 0
    halted = 0

Complete the following synthesizable SystemVerilog module:

module cpu_8bit (
    input wire clk,
    input wire reset_n,
    input wire enable,
    input wire [7:0] instruction,
    input wire [7:0] in_port,

    output reg [3:0] pc,
    output reg [7:0] accumulator,
    output reg [7:0] out_port,
    output reg out_valid,
    output reg halted
);

    // Insert your implementation here

endmodule

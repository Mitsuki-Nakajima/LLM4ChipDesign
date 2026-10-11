I am trying to create a Verilog model for a sequence generator. It must meet the following specifications:

- Inputs:
    - Clock (signal name: clk)
    - Active-low reset (signal name: reset_n)
    - Enable (signal name: enable)

- Outputs:
    - Data (8 bits, signal name: data)

While enabled, it should generate an output sequence of the following hexadecimal values and then repeat:

    8'hAF
    8'hBC
    8'hE2
    8'h78
    8'hFF
    8'hE2
    8'h0B
    8'h8D

When enable is low, the sequence generator should hold its current output value.

IMPORTANT:
The design is compiled as SystemVerilog using Icarus Verilog with -g2012.
Do not use the identifier "sequence" as a variable, register, array, or signal name because "sequence" is a reserved SystemVerilog keyword.
Use another name such as seq_mem or sequence_data instead.

Complete the following synthesizable Verilog module:

module sequence_generator (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg [7:0] data
);

    // Insert your code here

endmodule

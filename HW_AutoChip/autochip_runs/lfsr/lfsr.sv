I am trying to create a Verilog model for an LFSR. It must meet the following specifications:

- Inputs:
    - Clock (signal name: clk)
    - Active-low reset (signal name: reset_n)

- Outputs:
    - Data (8 bits, signal name: data)

The initial state should be 8'b10001010.

The taps should be at locations 1, 4, 6, and 7.

For each clock cycle, the next LFSR state should be formed as:

    {data[6:0], data[0] ^ data[3] ^ data[5] ^ data[6]}

When reset_n is low, the LFSR should return to the initial state 8'b10001010.

Complete the following synthesizable Verilog module:

module lfsr (
    input wire clk,
    input wire reset_n,
    output reg [7:0] data
);

    // Insert your code here

endmodule

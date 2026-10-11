I am trying to create a Verilog model for a shift register. It must meet the following specifications:

- Inputs:
    - Clock (signal name: clk)
    - Active-low reset (signal name: reset_n)
    - Data (1 bit, signal name: data_in)
    - Shift enable (signal name: shift_enable)

- Outputs:
    - Data (8 bits, signal name: data_out)

When reset_n is low, data_out should reset to 8'b00000000.

When shift_enable is high, on each rising edge of clk the register should shift left by one bit and insert data_in into the least significant bit.

When shift_enable is low, the current value should be held.

Complete the following synthesizable Verilog module:

module shift_register (
    input wire clk,
    input wire reset_n,
    input wire data_in,
    input wire shift_enable,
    output reg [7:0] data_out
);

    // Insert your code here

endmodule

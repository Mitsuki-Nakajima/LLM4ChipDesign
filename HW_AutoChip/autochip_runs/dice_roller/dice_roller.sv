I am trying to create a Verilog model for a simulated dice roller. It must meet the following specifications:

- Inputs:
    - Clock (signal name: clk)
    - Active-low reset (signal name: rst_n)
    - Die select (2 bits, signal name: die_select)
    - Roll (signal name: roll)

- Outputs:
    - Rolled number (8 bits, signal name: rolled_number)

The design should simulate rolling either a 4-sided, 6-sided, 8-sided, or 20-sided die, based on the input die_select.

Use the following mapping:
- die_select = 2'b00: 4-sided die
- die_select = 2'b01: 6-sided die
- die_select = 2'b10: 8-sided die
- die_select = 2'b11: 20-sided die

When roll goes high, the design should produce a pseudo-random result within the valid range of the selected die.

Complete the following synthesizable Verilog module:

module dice_roller (
    input wire clk,
    input wire rst_n,
    input wire [1:0] die_select,
    input wire roll,
    output reg [7:0] rolled_number
);

    // Insert your code here

endmodule

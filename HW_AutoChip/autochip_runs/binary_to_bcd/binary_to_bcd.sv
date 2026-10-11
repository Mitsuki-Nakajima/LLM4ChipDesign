I am trying to create a Verilog model with name binary_to_bcd_converter for a binary to binary-coded-decimal converter. It must meet the following specifications:

- Inputs:
    - Binary input (5-bits, signal name: binary_input)

- Outputs:
    - BCD (8-bits: 4-bits for the 10's place and 4-bits for the 1's place, signal name: bcd_output)

Complete the following synthesizable Verilog module:

module binary_to_bcd_converter (
    input  [4:0] binary_input,
    output reg [7:0] bcd_output
);

    // Insert your code here

endmodule

I am trying to create a Verilog model for a sequence detector. It must meet the following specifications:

- Inputs:
    - Clock (signal name: clk)
    - Active-low reset (signal name: reset_n)
    - Data (3 bits, signal name: data)

- Outputs:
    - Sequence found (signal name: sequence_found)

While enabled, it should detect the following sequence of binary input values:

    - 3'b001
    - 3'b101
    - 3'b110
    - 3'b000
    - 3'b110
    - 3'b110
    - 3'b011
    - 3'b101

The output sequence_found should remain low while receiving the sequence and should become high when the complete sequence has been detected.

Complete the following synthesizable Verilog module:

module sequence_detector (
    input clk,
    input reset_n,
    input [2:0] data,
    output reg sequence_found
);

    // Insert your code here

endmodule

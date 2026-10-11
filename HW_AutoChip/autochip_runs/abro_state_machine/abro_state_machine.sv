I am trying to create a Verilog model for an ABRO state machine. It must meet the following specifications:

- Inputs:
    - Clock (signal name: clk)
    - Active-low reset (signal name: rst_n)
    - A (signal name: A)
    - B (signal name: B)

- Outputs:
    - O (signal name: O)
    - State (4 bits, signal name: State)

Other than the main output from the ABRO machine, it should output the current state of the machine for use in verification.

The states for this state machine should be one-hot encoded.

Complete the following synthesizable Verilog module:

module abro_state_machine (
    input wire clk,
    input wire rst_n,
    input wire A,
    input wire B,
    output reg O,
    output reg [3:0] State
);

    // Insert your code here

endmodule

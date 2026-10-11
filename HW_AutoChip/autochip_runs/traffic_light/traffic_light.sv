I am trying to create a Verilog model for a traffic light state machine. It must meet the following specifications:

- Inputs:
    - Clock (signal name: clk)
    - Active-low reset (signal name: reset_n)
    - Enable (signal name: enable)

- Outputs:
    - Red (signal name: red)
    - Yellow (signal name: yellow)
    - Green (signal name: green)

The state machine should reset to the RED state.

While enable is high:
- Stay RED for 32 clock cycles, then transition to GREEN.
- Stay GREEN for 20 clock cycles, then transition to YELLOW.
- Stay YELLOW for 7 clock cycles, then transition back to RED.
- Repeat this cycle continuously.

When enable is low, the state machine should hold its current state and counter.

Complete the following synthesizable Verilog module:

module traffic_light_fsm (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg red,
    output reg yellow,
    output reg green
);

    // Insert your code here

endmodule

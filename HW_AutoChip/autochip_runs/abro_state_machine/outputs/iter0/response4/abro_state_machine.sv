module abro_state_machine (
    input wire clk,
    input wire rst_n,
    input wire A,
    input wire B,
    output reg O,
    output reg [3:0] State
);

    // State encoding
    parameter S0 = 4'b0001; // State 0
    parameter S1 = 4'b0010; // State 1
    parameter S2 = 4'b0100; // State 2
    parameter S3 = 4'b1000; // State 3

    reg [3:0] current_state, next_state;

    // State transition logic
    always @* begin
        case (current_state)
            S0: begin
                if (A) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                if (B) next_state = S2;
                else next_state = S1;
            end
            S2: begin
                if (A) next_state = S3;
                else next_state = S0;
            end
            S3: begin
                if (B) next_state = S0;
                else next_state = S3;
            end
            default: next_state = S0; // Reset to state 0
        endcase
    end

    // State update and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;
            O <= 0;
        end else begin
            current_state <= next_state;
            // Output logic: just an example, assuming O goes high in state S2
            if (current_state == S2)
                O <= 1;
            else
                O <= 0;
        end
        State <= current_state; // Output the current state
    end

endmodule

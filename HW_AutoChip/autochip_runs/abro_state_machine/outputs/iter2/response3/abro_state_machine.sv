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

    // Current state variable
    reg [3:0] current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0; // Initialize to state S0 on reset
            O <= 1'b0;           // Initialize output O
        end else begin
            current_state <= next_state; // Update state on clock edge
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        // Default values
        next_state = current_state;
        O = 1'b0; // Default output

        case (current_state)
            S0: begin
                if (A) begin
                    next_state = S1;
                end
            end
            S1: begin
                if (B) begin
                    next_state = S2;
                end else if (!A) begin
                    next_state = S0; // Return to state S0 if A is low
                end
            end
            S2: begin
                O = 1'b1; // Output active in state S2
                next_state = S3; // Move to state S3 on next clock
            end
            S3: begin
                if (!A && B) begin
                    next_state = S2; // Transition back to S2 with A low and B high
                end else if (A) begin
                    next_state = S1; // Allow a transition back to S1 with A high
                end else begin
                    next_state = S0; // Default to state S0 with A and B low
                end
            end
        endcase
    end

    // Output current state
    always @(*) begin
        State = current_state;
    end

endmodule

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
                if (A) begin
                    next_state = S3; // Move to S3 if A is high
                end
            end
            S3: begin
                O = 1'b1; // Output active in state S3
                if (!A && B) begin
                    next_state = S2; // Return to S2 if A is low and B is high
                end else if (!A) begin
                    next_state = S0; // Return to state S0 if A is low
                end
            end
        endcase
    end

    // Output current state
    always @(*) begin
        State = current_state;
    end

endmodule

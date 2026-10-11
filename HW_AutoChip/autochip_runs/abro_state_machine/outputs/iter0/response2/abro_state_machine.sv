module abro_state_machine (
    input wire clk,
    input wire rst_n,
    input wire A,
    input wire B,
    output reg O,
    output reg [3:0] State
);

    // State encoding
    parameter S0 = 4'b0001, 
              S1 = 4'b0010, 
              S2 = 4'b0100, 
              S3 = 4'b1000;

    // Current state and next state registers
    reg [3:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (A) 
                    next_state = S1;
                else 
                    next_state = S0;
            end
            S1: begin
                if (B) 
                    next_state = S2;
                else 
                    next_state = S1;
            end
            S2: begin
                if (A) 
                    next_state = S3;
                else 
                    next_state = S0;
            end
            S3: begin
                if (B) 
                    next_state = S0;
                else 
                    next_state = S3;
            end
            default: next_state = S0;
        endcase
    end

    // State update and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;
            O <= 1'b0;
        end else begin
            current_state <= next_state;
            O <= (current_state == S3); // Example output condition
        end
    end

    // Assign current state to output State
    always @(*) begin
        State = current_state;
    end

endmodule

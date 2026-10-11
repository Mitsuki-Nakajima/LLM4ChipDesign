module sequence_detector (
    input clk,
    input reset_n,
    input [2:0] data,
    output reg sequence_found
);

    typedef enum reg [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b101,
        S3 = 3'b110,
        S4 = 3'b000,
        S5 = 3'b110,
        S6 = 3'b110,
        S7 = 3'b011,
        S8 = 3'b101
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= S0;
            sequence_found <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            S0: next_state = (data == S1) ? S1 : S0;
            S1: next_state = (data == S2) ? S2 : S0;
            S2: next_state = (data == S3) ? S3 : S0;
            S3: next_state = (data == S4) ? S4 : S0;
            S4: next_state = (data == S5) ? S5 : S0;
            S5: next_state = (data == S6) ? S6 : S0;
            S6: next_state = (data == S7) ? S7 : S0;
            S7: next_state = (data == S8) ? S8 : S0;
            S8: begin
                sequence_found = 1; // Sequence detected
                next_state = S0; // Reset to initial state
            end
            default: next_state = S0;
        endcase
    end

endmodule

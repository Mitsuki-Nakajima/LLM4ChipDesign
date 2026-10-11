module sequence_detector (
    input clk,
    input reset_n,
    input [2:0] data,
    output reg sequence_found
);

    typedef enum logic [3:0] {
        IDLE,
        S1,
        S2,
        S3,
        S4,
        S5,
        S6,
        S7
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_found <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        sequence_found = 0; // Default to low
        
        case (current_state)
            IDLE: begin
                if (data == 3'b001) next_state = S1;
            end
            S1: begin
                if (data == 3'b101) next_state = S2;
                else next_state = IDLE;
            end
            S2: begin
                if (data == 3'b110) next_state = S3;
                else next_state = IDLE;
            end
            S3: begin
                if (data == 3'b000) next_state = S4;
                else next_state = IDLE;
            end
            S4: begin
                if (data == 3'b110) next_state = S5;
                else next_state = IDLE;
            end
            S5: begin
                if (data == 3'b110) next_state = S6;
                else next_state = IDLE;
            end
            S6: begin
                if (data == 3'b011) next_state = S7;
                else next_state = IDLE;
            end
            S7: begin
                if (data == 3'b101) begin
                    sequence_found = 1; // Sequence detected
                    next_state = IDLE; // Go back to IDLE after detection
                end else begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule

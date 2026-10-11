module sequence_detector (
    input clk,
    input reset_n,
    input [2:0] data,
    output reg sequence_found
);

    typedef enum logic [2:0] {
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
        case (current_state)
            IDLE: begin
                if (data == 3'b001) begin
                    next_state = S1;
                end else begin
                    next_state = IDLE;
                end
                sequence_found = 0;
            end
            S1: begin
                if (data == 3'b101) begin
                    next_state = S2;
                end else begin
                    next_state = IDLE;
                end
                sequence_found = 0;
            end
            S2: begin
                if (data == 3'b110) begin
                    next_state = S3;
                end else begin
                    next_state = IDLE;
                end
                sequence_found = 0;
            end
            S3: begin
                if (data == 3'b000) begin
                    next_state = S4;
                end else begin
                    next_state = IDLE;
                end
                sequence_found = 0;
            end
            S4: begin
                if (data == 3'b110) begin
                    next_state = S5;
                end else begin
                    next_state = IDLE;
                end
                sequence_found = 0;
            end
            S5: begin
                if (data == 3'b110) begin
                    next_state = S6;
                end else begin
                    next_state = IDLE;
                end
                sequence_found = 0;
            end
            S6: begin
                if (data == 3'b011) begin
                    next_state = S7;
                end else begin
                    next_state = IDLE;
                end
                sequence_found = 0;
            end
            S7: begin
                if (data == 3'b101) begin
                    sequence_found = 1;
                    next_state = IDLE; // Go back to IDLE after finding the sequence
                end else begin
                    next_state = IDLE;
                end
                sequence_found = 0;
            end
            default: begin
                next_state = IDLE;
                sequence_found = 0;
            end
        endcase
    end

endmodule

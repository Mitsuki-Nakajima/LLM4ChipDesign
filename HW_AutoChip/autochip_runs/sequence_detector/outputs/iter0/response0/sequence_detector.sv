module sequence_detector (
    input clk,
    input reset_n,
    input [2:0] data,
    output reg sequence_found
);
    // State encoding for the sequence detector
    typedef enum reg [3:0] {
        IDLE = 4'b0000,
        S1   = 4'b0001, // 3'b001
        S2   = 4'b0010, // 3'b101
        S3   = 4'b0011, // 3'b110
        S4   = 4'b0100, // 3'b000
        S5   = 4'b0101, // 3'b110
        S6   = 4'b0110, // 3'b110
        S7   = 4'b0111, // 3'b011
        S8   = 4'b1000  // 3'b101
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        // Default next state
        next_state = current_state;
        sequence_found = 1'b0; // Default to low

        case (current_state)
            IDLE: begin
                if (data == 3'b001)
                    next_state = S1;
            end
            S1: begin
                if (data == 3'b101)
                    next_state = S2;
            end
            S2: begin
                if (data == 3'b110)
                    next_state = S3;
            end
            S3: begin
                if (data == 3'b000)
                    next_state = S4;
            end
            S4: begin
                if (data == 3'b110)
                    next_state = S5;
            end
            S5: begin
                if (data == 3'b110)
                    next_state = S6;
            end
            S6: begin
                if (data == 3'b011)
                    next_state = S7;
            end
            S7: begin
                if (data == 3'b101) begin
                    next_state = S8;
                    sequence_found = 1'b1; // Complete sequence found
                end
            end
            S8: begin
                sequence_found = 1'b1; // Maintain high state for output
                if (data != 3'b101)  // Reset to avoid locking in if wrong data next
                    next_state = IDLE;
            end
            default: begin
                next_state = IDLE; // Default to IDLE state
            end
        endcase
    end
endmodule

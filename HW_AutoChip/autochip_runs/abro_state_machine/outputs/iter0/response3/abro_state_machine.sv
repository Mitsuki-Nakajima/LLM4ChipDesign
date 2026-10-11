module abro_state_machine (
    input wire clk,
    input wire rst_n,
    input wire A,
    input wire B,
    output reg O,
    output reg [3:0] State
);

    // State encoding
    parameter IDLE = 4'b0001;
    parameter STATE_A = 4'b0010;
    parameter STATE_B = 4'b0100;
    parameter STATE_AB = 4'b1000;

    // Current state and next state variables
    reg [3:0] current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (A) begin
                    next_state = STATE_A;
                    O = 1'b0; // Output for IDLE
                end else if (B) begin
                    next_state = STATE_B;
                    O = 1'b0; // Output for IDLE
                end else begin
                    next_state = IDLE;
                    O = 1'b0; // Output for IDLE
                end
            end
            STATE_A: begin
                if (B) begin
                    next_state = STATE_AB;
                    O = 1'b1; // Output for STATE_A
                end else begin
                    next_state = STATE_A;
                    O = 1'b1; // Output for STATE_A
                end
            end
            STATE_B: begin
                if (A) begin
                    next_state = STATE_AB;
                    O = 1'b1; // Output for STATE_B
                end else begin
                    next_state = STATE_B;
                    O = 1'b1; // Output for STATE_B
                end
            end
            STATE_AB: begin
                next_state = IDLE;
                O = 1'b0; // Output for STATE_AB
            end
            default: begin
                next_state = IDLE;
                O = 1'b0; // Default output
            end
        endcase
    end

    // Update the State output
    always @(*) begin
        State = current_state;
    end

endmodule

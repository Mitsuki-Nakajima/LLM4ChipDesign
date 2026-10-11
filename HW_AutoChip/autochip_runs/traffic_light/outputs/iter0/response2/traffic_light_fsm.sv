module traffic_light_fsm (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg red,
    output reg yellow,
    output reg green
);

    typedef enum reg [1:0] {
        RED,
        GREEN,
        YELLOW
    } state_t;

    state_t current_state, next_state;
    reg [5:0] counter; // 6 bits to count up to 64

    // State transition logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 0;
        end else if (enable) begin
            current_state <= next_state;
            counter <= (counter < 63) ? counter + 1 : 0; // Wrap around counter
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            RED: begin
                if (enable && counter == 31) // Stay RED for 32 cycles
                    next_state = GREEN;
                else
                    next_state = RED;
            end
            GREEN: begin
                if (enable && counter == 19) // Stay GREEN for 20 cycles
                    next_state = YELLOW;
                else
                    next_state = GREEN;
            end
            YELLOW: begin
                if (enable && counter == 6) // Stay YELLOW for 7 cycles
                    next_state = RED;
                else
                    next_state = YELLOW;
            end
            default: next_state = RED; // Fallback state
        endcase
    end

    // Output logic
    always @(*) begin
        red = (current_state == RED);
        yellow = (current_state == YELLOW);
        green = (current_state == GREEN);
    end

endmodule

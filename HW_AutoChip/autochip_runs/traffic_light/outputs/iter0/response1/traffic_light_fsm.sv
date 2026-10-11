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
    reg [5:0] counter; // 6 bits for counting maximum 63

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 0;
        end else if (enable) begin
            current_state <= next_state;
            if (current_state == next_state) counter <= counter + 1;
            else counter <= 0;
        end
    end

    always @(*) begin
        // Default output values
        red = 0;
        yellow = 0;
        green = 0;
        next_state = current_state;

        case (current_state)
            RED: begin
                red = 1;
                if (counter >= 32) begin
                    next_state = GREEN;
                end
            end
            GREEN: begin
                green = 1;
                if (counter >= 20) begin
                    next_state = YELLOW;
                end
            end
            YELLOW: begin
                yellow = 1;
                if (counter >= 7) begin
                    next_state = RED;
                end
            end
        endcase
    end

endmodule

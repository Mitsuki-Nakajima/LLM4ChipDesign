module traffic_light_fsm (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg red,
    output reg yellow,
    output reg green
);

    typedef enum reg [1:0] {
        RED     = 2'b00,
        GREEN   = 2'b01,
        YELLOW  = 2'b10
    } state_t;

    state_t current_state, next_state;

    reg [5:0] counter; // for timing, enough to count for 32 cycles

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 0;
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else if (enable) begin
            current_state <= next_state;
            if (current_state == RED) begin
                // Reset counter for RED
                counter <= 0;
            end else if (current_state == GREEN) begin
                // Reset counter for GREEN
                counter <= 0;
            end else if (current_state == YELLOW) begin
                // Reset counter for YELLOW
                counter <= 0;
            end
        end
    end

    always @(posedge clk) begin
        if (enable) begin
            counter <= counter + 1;
            case (current_state)
                RED: begin
                    if (counter >= 32) begin
                        next_state <= GREEN;
                        red <= 0;
                        green <= 1;
                        yellow <= 0;
                    end else begin
                        next_state <= RED;
                        red <= 1;
                        green <= 0;
                        yellow <= 0;
                    end
                end
                GREEN: begin
                    if (counter >= 20) begin
                        next_state <= YELLOW;
                        red <= 0;
                        green <= 0;
                        yellow <= 1;
                    end else begin
                        next_state <= GREEN;
                        red <= 0;
                        green <= 1;
                        yellow <= 0;
                    end
                end
                YELLOW: begin
                    if (counter >= 7) begin
                        next_state <= RED;
                        red <= 1;
                        green <= 0;
                        yellow <= 0;
                    end else begin
                        next_state <= YELLOW;
                        red <= 0;
                        green <= 0;
                        yellow <= 1;
                    end
                end
                default: begin
                    next_state <= RED;
                    red <= 1;
                    green <= 0;
                    yellow <= 0;
                end
            endcase
        end
    end

endmodule

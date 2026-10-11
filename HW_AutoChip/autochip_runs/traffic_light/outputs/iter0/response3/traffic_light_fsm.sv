module traffic_light_fsm (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg red,
    output reg yellow,
    output reg green
);

    typedef enum reg [1:0] {
        RED = 2'b00,
        GREEN = 2'b01,
        YELLOW = 2'b10
    } state_t;

    state_t current_state, next_state;
    reg [5:0] counter; // Sufficient to count up to 32 + 20 + 7

    // State transition chart
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 0;
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else if (enable) begin
            current_state <= next_state;
            counter <= (counter < 63) ? counter + 1 : 0; // count reset after it reaches maximum
            
            // Output logic based on current state
            case (current_state)
                RED: begin
                    if (counter >= 32) begin
                        next_state <= GREEN;
                        counter <= 0;
                    end
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end
                GREEN: begin
                    if (counter >= 20) begin
                        next_state <= YELLOW;
                        counter <= 0;
                    end
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end
                YELLOW: begin
                    if (counter >= 7) begin
                        next_state <= RED;
                        counter <= 0;
                    end
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end
                default: begin
                    next_state <= RED;
                end
            endcase
        end else begin
            // Hold current state and counter
            case (current_state)
                RED: begin
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end
                GREEN: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end
                YELLOW: begin
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end
            endcase
        end
    end

endmodule

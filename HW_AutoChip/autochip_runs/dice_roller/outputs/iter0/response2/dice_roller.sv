module dice_roller (
    input wire clk,
    input wire rst_n,
    input wire [1:0] die_select,
    input wire roll,
    output reg [7:0] rolled_number
);

    reg [7:0] max_value;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 8'b0;
            max_value <= 8'b0;
        end else if (roll) begin
            case (die_select)
                2'b00: max_value <= 4;   // 4-sided die
                2'b01: max_value <= 6;   // 6-sided die
                2'b10: max_value <= 8;   // 8-sided die
                2'b11: max_value <= 20;  // 20-sided die
                default: max_value <= 8'b0; // Default case to prevent latches
            endcase

            // Generate a pseudo-random number based on the current time (clk count)
            rolled_number <= (max_value > 0) ? ($random % max_value) + 1 : 0;
        end
    end

endmodule

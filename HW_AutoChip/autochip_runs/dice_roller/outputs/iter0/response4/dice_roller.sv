module dice_roller (
    input wire clk,
    input wire rst_n,
    input wire [1:0] die_select,
    input wire roll,
    output reg [7:0] rolled_number
);

    reg [7:0] max_roll;

    always @(*) begin
        case (die_select)
            2'b00: max_roll = 4;   // 4-sided die
            2'b01: max_roll = 6;   // 6-sided die
            2'b10: max_roll = 8;   // 8-sided die
            2'b11: max_roll = 20;  // 20-sided die
            default: max_roll = 4; // default to 4-sided die
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 8'b0;
        end else if (roll) begin
            rolled_number <= $urandom_range(1, max_roll);  // Generate random number in the range [1, max_roll]
        end
    end

endmodule

module dice_roller (
    input wire clk,
    input wire rst_n,
    input wire [1:0] die_select,
    input wire roll,
    output reg [7:0] rolled_number
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 8'b0;
        end else if (roll) begin
            case (die_select)
                2'b00: rolled_number <= $urandom % 4 + 1;  // 4-sided die
                2'b01: rolled_number <= $urandom % 6 + 1;  // 6-sided die
                2'b10: rolled_number <= $urandom % 8 + 1;  // 8-sided die
                2'b11: rolled_number <= $urandom % 20 + 1; // 20-sided die
                default: rolled_number <= 8'b0; // Default case (should not happen)
            endcase
        end
    end

endmodule

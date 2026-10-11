module dice_roller (
    input wire clk,
    input wire rst_n,
    input wire [1:0] die_select,
    input wire roll,
    output reg [7:0] rolled_number
);

    // Pseudo-random number generator seed
    reg [7:0] rand_seed;

    // Internal signals
    reg [7:0] max_value;

    // Process to determine the maximum value based on die_select
    always @(*) begin
        case (die_select)
            2'b00: max_value = 4;   // 4-sided die
            2'b01: max_value = 6;   // 6-sided die
            2'b10: max_value = 8;   // 8-sided die
            2'b11: max_value = 20;  // 20-sided die
            default: max_value = 1;  // Default to 1 to avoid division by zero
        endcase
    end

    // Process to generate rolled_number
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 0;
            rand_seed <= 8'h1; // Initialize the seed to a non-zero value
        end else if (roll) begin
            // Simple pseudo-random number generation
            rand_seed <= {rand_seed[6:0], rand_seed[7] ^ rand_seed[5] ^ rand_seed[4] ^ rand_seed[3]};
            rolled_number <= (rand_seed % max_value) + 1; // Generates a number in the range [1, max_value]
        end
    end

endmodule

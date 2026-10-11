module sequence_generator (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg [7:0] data
);

    // Sequence of values
    reg [7:0] seq_mem [0:7];
    reg [2:0] index;

    initial begin
        seq_mem[0] = 8'hAF;
        seq_mem[1] = 8'hBC;
        seq_mem[2] = 8'hE2;
        seq_mem[3] = 8'h78;
        seq_mem[4] = 8'hFF;
        seq_mem[5] = 8'hE2;
        seq_mem[6] = 8'h0B;
        seq_mem[7] = 8'h8D;
        index = 3'b000; // Start from the first value
        data = seq_mem[index];
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            index <= 3'b000; // Reset the index on reset
            data <= seq_mem[index];
        end else if (enable) begin
            data <= seq_mem[index];

            // Update index to point to the next value
            index <= (index + 1) % 8; // Wrap around after last value
        end
    end

endmodule

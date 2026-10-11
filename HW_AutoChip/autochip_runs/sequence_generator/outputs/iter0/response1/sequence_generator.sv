module sequence_generator (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg [7:0] data
);

    reg [2:0] index;
    reg [7:0] seq_mem [0:7] = {8'hAF, 8'hBC, 8'hE2, 8'h78, 8'hFF, 8'hE2, 8'h0B, 8'h8D};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            index <= 0;
            data <= 8'h00;  // Initialize data on reset
        end else if (enable) begin
            data <= seq_mem[index];
            index <= (index == 7) ? 0 : index + 1;  // Circular increment of index
        end
    end

endmodule

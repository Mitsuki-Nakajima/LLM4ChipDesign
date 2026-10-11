module sequence_generator (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg [7:0] data
);

    reg [2:0] current_index;
    reg [7:0] seq_mem [0:7];

    initial begin
        seq_mem[0] = 8'hAF;
        seq_mem[1] = 8'hBC;
        seq_mem[2] = 8'hE2;
        seq_mem[3] = 8'h78;
        seq_mem[4] = 8'hFF;
        seq_mem[5] = 8'hE2;
        seq_mem[6] = 8'h0B;
        seq_mem[7] = 8'h8D;
        current_index = 3'b000; // Start with the first element
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_index <= 3'b000; // Reset to the first element
            data <= seq_mem[current_index];
        end else if (enable) begin
            data <= seq_mem[current_index];
            current_index <= current_index + 1'b1;
            if (current_index == 3'b111) begin
                current_index <= 3'b000; // Loop back to the start
            end
        end
    end

endmodule

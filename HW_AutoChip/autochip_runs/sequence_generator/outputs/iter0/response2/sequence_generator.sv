module sequence_generator (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg [7:0] data
);
    reg [2:0] count; // 3-bit counter to cycle through the sequence
    reg [7:0] seq_mem [0:7]; // Memory array to hold sequence values

    initial begin
        // Initializing the sequence values
        seq_mem[0] = 8'hAF;
        seq_mem[1] = 8'hBC;
        seq_mem[2] = 8'hE2;
        seq_mem[3] = 8'h78;
        seq_mem[4] = 8'hFF;
        seq_mem[5] = 8'hE2;
        seq_mem[6] = 8'h0B;
        seq_mem[7] = 8'h8D;
        count = 3'b000; // Start with the first element
        data = 8'h00; // Initialize data
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 3'b000; // Reset count on active-low reset
            data <= 8'h00; // Reset output data
        end else if (enable) begin
            data <= seq_mem[count]; // Output current sequence value
            count <= count + 1'b1; // Increment count
            if (count == 3'b111) begin
                count <= 3'b000; // Wrap around to the start if at the end of the sequence
            end
        end
    end
endmodule

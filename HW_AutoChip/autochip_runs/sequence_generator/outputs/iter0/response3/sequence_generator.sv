module sequence_generator (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg [7:0] data
);
    reg [2:0] state; // 3-bit state to represent the 8 states
    reg [7:0] seq_mem [0:7]; // Memory to hold the sequence

    initial begin
        // Initialize the sequence values
        seq_mem[0] = 8'hAF;
        seq_mem[1] = 8'hBC;
        seq_mem[2] = 8'hE2;
        seq_mem[3] = 8'h78;
        seq_mem[4] = 8'hFF;
        seq_mem[5] = 8'hE2;
        seq_mem[6] = 8'h0B;
        seq_mem[7] = 8'h8D;
        state = 3'b000; // Start state
        data = seq_mem[state]; // Initialize output
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 3'b000; // Reset state
            data <= seq_mem[state]; // Reset output
        end else if (enable) begin
            // Update state and output data based on the current state
            data <= seq_mem[state];
            state <= (state + 1) % 8; // Loop back after last value
        end
    end
endmodule

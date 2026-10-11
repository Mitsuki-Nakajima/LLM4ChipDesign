module sequence_generator (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg [7:0] data
);

    reg [2:0] state;
    reg [7:0] sequence [0:7];

    initial begin
        sequence[0] = 8'hAF;
        sequence[1] = 8'hBC;
        sequence[2] = 8'hE2;
        sequence[3] = 8'h78;
        sequence[4] = 8'hFF;
        sequence[5] = 8'hE2;
        sequence[6] = 8'h0B;
        sequence[7] = 8'h8D;
        state = 0;
        data = sequence[state];
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 0;
            data <= sequence[state];
        end else if (enable) begin
            state <= (state + 1) % 8;
            data <= sequence[state];
        end
    end

endmodule


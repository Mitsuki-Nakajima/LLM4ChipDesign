module shift_register (
    input wire clk,
    input wire reset_n,
    input wire data_in,
    input wire shift_enable,
    output reg [7:0] data_out
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data_out <= 8'b00000000; // Reset data_out to 0 on active-low reset
        end else if (shift_enable) begin
            data_out <= {data_out[6:0], data_in}; // Shift left and insert data_in
        end
        // If shift_enable is low, data_out holds its value
    end

endmodule

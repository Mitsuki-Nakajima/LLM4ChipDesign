module binary_to_bcd_converter (
    input  [4:0] binary_input,
    output reg [7:0] bcd_output
);
    
    integer i;

    always @(*) begin
        // Initialize BCD output
        bcd_output = 8'b0;

        // Shift and add algorithm for BCD conversion
        for (i = 0; i < 5; i = i + 1) begin
            // Shift left by 1
            bcd_output = {bcd_output[6:0], binary_input[4-i]};
            
            // Adjust BCD digits if necessary
            if (bcd_output[3:0] > 4'd9) begin
                bcd_output[3:0] = bcd_output[3:0] + 4'b0011; // Add 3 to 1's place
            end
            if (bcd_output[7:4] > 4'd9) begin
                bcd_output[7:4] = bcd_output[7:4] + 4'b0011; // Add 3 to 10's place
            end
        end
    end

endmodule

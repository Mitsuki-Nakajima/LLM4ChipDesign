module binary_to_bcd_converter (
    input  [4:0] binary_input,
    output reg [7:0] bcd_output
);
    integer i;

    always @(*) begin
        // Initialize BCD output to 0
        bcd_output = 8'b0;

        // Convert binary to BCD
        for (i = 0; i < 5; i = i + 1) begin
            // Shift left to make space for the new bit
            if (bcd_output[7:4] >= 5) bcd_output[7:4] = bcd_output[7:4] + 3;
            if (bcd_output[3:0] >= 5) bcd_output[3:0] = bcd_output[3:0] + 3;

            // Shift to the left to make room for the next bit
            bcd_output = {bcd_output[6:0], binary_input[4-i]};
        end
    end

endmodule

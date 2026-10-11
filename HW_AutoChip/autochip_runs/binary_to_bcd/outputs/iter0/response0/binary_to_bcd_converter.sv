module binary_to_bcd_converter (
    input  [4:0] binary_input,
    output reg [7:0] bcd_output
);
    integer i;

    always @(*) begin
        // Initialize BCD output to 0
        bcd_output = 8'b00000000;

        // Convert binary to BCD using double-dabble algorithm
        for (i = 0; i < 5; i = i + 1) begin
            // Shift left BCD output
            bcd_output = {bcd_output[6:0], binary_input[4-i]};
            
            // Add 3 to BCD output's tens and ones places if needed
            if (bcd_output[3:0] > 4'b1001) begin
                bcd_output[3:0] = bcd_output[3:0] + 4'b0011;
            end
            if (bcd_output[7:4] > 4'b1001) begin
                bcd_output[7:4] = bcd_output[7:4] + 4'b0011;
            end
        end
    end
endmodule

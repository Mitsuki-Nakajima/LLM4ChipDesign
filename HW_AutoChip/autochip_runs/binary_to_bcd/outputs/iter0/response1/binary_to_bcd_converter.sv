module binary_to_bcd_converter (
    input  [4:0] binary_input,
    output reg [7:0] bcd_output
);

    integer i;

    always @(*) begin
        // Initialize BCD output
        bcd_output = 0;

        // Shift-and-add-3 algorithm
        for (i = 0; i < 5; i = i + 1) begin
            // Shift left by 1
            bcd_output = bcd_output << 1;
            // Add 3 if 10's or 1's digit is greater than 4
            if (bcd_output[7:4] > 4)
                bcd_output[7:4] = bcd_output[7:4] + 4;
            if (bcd_output[3:0] > 4)
                bcd_output[3:0] = bcd_output[3:0] + 4;

            // Add the next bit of binary_input
            bcd_output[0] = binary_input[4 - i];
        end
    end

endmodule

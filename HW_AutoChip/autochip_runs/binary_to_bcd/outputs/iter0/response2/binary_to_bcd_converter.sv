module binary_to_bcd_converter (
    input  [4:0] binary_input,
    output reg [7:0] bcd_output
);

    integer i;

    always @* begin
        // Initialize BCD output
        bcd_output = 8'b0;

        // Binary to BCD conversion using shift-and-add method
        for (i = 0; i < 5; i = i + 1) begin
            // Shift left by 1
            bcd_output = {bcd_output[6:0], 1'b0};

            // Add 3 to BCD digits if they are 5 or greater
            if (bcd_output[3:0] >= 5)
                bcd_output[3:0] = bcd_output[3:0] + 4'b0011;
            if (bcd_output[7:4] >= 5)
                bcd_output[7:4] = bcd_output[7:4] + 4'b0011;

            // Add the next binary input bit
            bcd_output[0] = binary_input[4 - i];
        end
    end

endmodule

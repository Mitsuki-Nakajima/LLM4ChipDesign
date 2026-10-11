
`timescale 1ns / 1ps

module tb;

    reg [4:0] binary_input;
    wire [7:0] bcd_output;

    integer i;
    integer mismatches;

    reg [4:0] test_binary;
    reg [7:0] expected_bcd;

    binary_to_bcd_converter uut (
        .binary_input(binary_input),
        .bcd_output(bcd_output)
    );

    initial begin
        $dumpfile("my_design.vcd");
        $dumpvars(0, tb);

        $display("Testing Binary-to-BCD Converter...");

        mismatches = 0;
        binary_input = 0;
        test_binary = 0;
        expected_bcd = 0;

        for (i = 0; i < 32; i = i + 1) begin
            test_binary = i;
            binary_input = test_binary;

            expected_bcd[3:0] = test_binary % 10;
            expected_bcd[7:4] = test_binary / 10;

            #10;

            if (bcd_output !== expected_bcd) begin
                mismatches = mismatches + 1;

                $display(
                    "Error: Test case %0d failed. Expected BCD: 8'b%08b, Got: 8'b%08b",
                    test_binary,
                    expected_bcd,
                    bcd_output
                );
            end
        end

        $display("Mismatches: %0d in 32 samples", mismatches);
    end

endmodule

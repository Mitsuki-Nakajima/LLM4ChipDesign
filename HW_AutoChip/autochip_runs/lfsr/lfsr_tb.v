
`timescale 1ns / 1ps

module tb;

    reg clk;
    reg run_clk;
    reg reset_n;

    wire [7:0] data;

    integer i;
    integer mismatches;
    integer samples;

    reg [7:0] data_expected;

    lfsr dut (
        .clk(clk),
        .reset_n(reset_n),
        .data(data)
    );

    function [7:0] reference_lfsr_output;
        input [7:0] current_state;
        begin
            reference_lfsr_output = {
                current_state[6:0],
                current_state[0] ^
                current_state[3] ^
                current_state[5] ^
                current_state[6]
            };
        end
    endfunction

    initial begin
        clk = 0;
        run_clk = 1;

        while (run_clk) begin
            #5;
            clk = ~clk;
        end
    end

    initial begin

        reset_n = 0;

        mismatches = 0;
        samples = 0;

        @(posedge clk);
        #1;

        samples = samples + 1;

        if (data !== 8'b10001010) begin
            mismatches = mismatches + 1;
        end

        @(negedge clk);
        reset_n = 1;

        data_expected = 8'b10001010;

        for (i = 0; i < 256; i = i + 1) begin

            data_expected =
                reference_lfsr_output(data_expected);

            @(posedge clk);
            #1;

            samples = samples + 1;

            if (data !== data_expected) begin
                mismatches = mismatches + 1;
            end
        end

        run_clk = 0;

        $display(
            "Mismatches: %0d in %0d samples",
            mismatches,
            samples
        );
    end

endmodule

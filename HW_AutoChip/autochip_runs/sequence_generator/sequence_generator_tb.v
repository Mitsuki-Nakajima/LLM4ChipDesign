
`timescale 1ns/1ps

module tb;

    reg clk;
    reg run_clk;
    reg reset_n;
    reg enable;

    wire [7:0] data;

    integer i;
    integer mismatches;
    integer samples;

    localparam TEST_SEQ_LEN = 8;

    reg [7:0] test_sequence [0:TEST_SEQ_LEN-1];

    sequence_generator dut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .data(data)
    );

    initial begin
        test_sequence[0] = 8'hAF;
        test_sequence[1] = 8'hBC;
        test_sequence[2] = 8'hE2;
        test_sequence[3] = 8'h78;
        test_sequence[4] = 8'hFF;
        test_sequence[5] = 8'hE2;
        test_sequence[6] = 8'h0B;
        test_sequence[7] = 8'h8D;
    end

    // Clock that terminates cleanly
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
        enable = 0;

        mismatches = 0;
        samples = 0;

        // Apply reset
        @(posedge clk);
        #1;

        // Release reset away from the rising edge
        @(negedge clk);
        reset_n = 1;

        // Begin sequence generation
        enable = 1;

        // First complete sequence
        for (i = 0; i < TEST_SEQ_LEN; i = i + 1) begin

            @(posedge clk);

            // Wait for nonblocking assignments to update data
            #1;

            samples = samples + 1;

            if (data !== test_sequence[i]) begin

                mismatches = mismatches + 1;

                $display(
                    "Error: Position %0d. Expected: %h, Got: %h",
                    i,
                    test_sequence[i],
                    data
                );
            end
        end

        // Verify that the sequence repeats
        for (i = 0; i < TEST_SEQ_LEN; i = i + 1) begin

            @(posedge clk);
            #1;

            samples = samples + 1;

            if (data !== test_sequence[i]) begin

                mismatches = mismatches + 1;

                $display(
                    "Error: Repeat position %0d. Expected: %h, Got: %h",
                    i,
                    test_sequence[i],
                    data
                );
            end
        end

        // Disable generator and verify that the last value is held
        enable = 0;

        @(posedge clk);
        #1;

        samples = samples + 1;

        if (data !== 8'h8D) begin

            mismatches = mismatches + 1;

            $display(
                "Error: Disabled generator should hold 8D, Got: %h",
                data
            );
        end

        run_clk = 0;

        $display(
            "Mismatches: %0d in %0d samples",
            mismatches,
            samples
        );
    end

endmodule

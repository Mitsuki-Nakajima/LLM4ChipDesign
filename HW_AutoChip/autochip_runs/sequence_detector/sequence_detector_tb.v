
`timescale 1ns/1ps

module tb;

    reg clk;
    reg run_clk;
    reg reset_n;
    reg [2:0] data;

    wire sequence_found;

    integer mismatches;
    integer samples;

    sequence_detector dut (
        .clk(clk),
        .reset_n(reset_n),
        .data(data),
        .sequence_found(sequence_found)
    );

    initial begin
        clk = 0;
        run_clk = 1;

        while (run_clk) begin
            #5;
            clk = ~clk;
        end
    end

    task apply_stimulus;
        input [2:0] data_value;
        begin
            data = data_value;
            @(posedge clk);
            #1;
        end
    endtask

    task check_output;
        input integer cycle;
        input expected_value;
        begin
            samples = samples + 1;

            if (sequence_found !== expected_value) begin
                mismatches = mismatches + 1;

                $display(
                    "Error: Cycle %0d, Expected: %b, Got: %b",
                    cycle,
                    expected_value,
                    sequence_found
                );
            end
        end
    endtask

    initial begin
        mismatches = 0;
        samples = 0;

        reset_n = 0;
        data = 3'b000;

        @(posedge clk);
        #1;
        reset_n = 1;

        apply_stimulus(3'b001);
        check_output(1, 1'b0);

        apply_stimulus(3'b101);
        check_output(2, 1'b0);

        apply_stimulus(3'b110);
        check_output(3, 1'b0);

        apply_stimulus(3'b000);
        check_output(4, 1'b0);

        apply_stimulus(3'b110);
        check_output(5, 1'b0);

        apply_stimulus(3'b110);
        check_output(6, 1'b0);

        apply_stimulus(3'b011);
        check_output(7, 1'b0);

        apply_stimulus(3'b101);
        check_output(8, 1'b1);

        apply_stimulus(3'b001);
        check_output(9, 1'b0);

        apply_stimulus(3'b101);
        check_output(10, 1'b0);

        apply_stimulus(3'b010);
        check_output(11, 1'b0);

        apply_stimulus(3'b000);
        check_output(12, 1'b0);

        run_clk = 0;

        $display(
            "Mismatches: %0d in %0d samples",
            mismatches,
            samples
        );
    end

endmodule

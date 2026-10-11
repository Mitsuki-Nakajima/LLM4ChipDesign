
`timescale 1ns/1ps

module tb;

    reg clk;
    reg run_clk;
    reg reset_n;
    reg data_in;
    reg shift_enable;

    wire [7:0] data_out;

    integer mismatches;
    integer samples;

    shift_register dut (
        .clk(clk),
        .reset_n(reset_n),
        .data_in(data_in),
        .shift_enable(shift_enable),
        .data_out(data_out)
    );

    initial begin
        clk = 0;
        run_clk = 1;

        while (run_clk) begin
            #5;
            clk = ~clk;
        end
    end

    task check_output;
        input [7:0] expected;
        begin
            samples = samples + 1;

            if (data_out !== expected) begin
                mismatches = mismatches + 1;

                $display(
                    "Mismatch: expected %08b, got %08b",
                    expected,
                    data_out
                );
            end
        end
    endtask

    task shift_and_check;
        input bit_in;
        input [7:0] expected;
        begin
            data_in = bit_in;
            shift_enable = 1'b1;

            @(posedge clk);
            #1;

            check_output(expected);
        end
    endtask

    initial begin
        mismatches = 0;
        samples = 0;

        reset_n = 1;
        data_in = 0;
        shift_enable = 0;

        reset_n = 0;
        #1;
        check_output(8'b00000000);

        reset_n = 1;

        shift_enable = 0;
        data_in = 0;

        @(posedge clk);
        #1;

        check_output(8'b00000000);

        shift_and_check(1'b0, 8'b00000000);
        shift_and_check(1'b1, 8'b00000001);
        shift_and_check(1'b1, 8'b00000011);
        shift_and_check(1'b0, 8'b00000110);
        shift_and_check(1'b1, 8'b00001101);

        shift_enable = 0;
        data_in = 0;

        @(posedge clk);
        #1;

        check_output(8'b00001101);

        reset_n = 0;
        #1;

        check_output(8'b00000000);

        run_clk = 0;

        $display(
            "Mismatches: %0d in %0d samples",
            mismatches,
            samples
        );
    end

endmodule

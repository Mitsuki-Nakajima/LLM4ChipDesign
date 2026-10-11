
`timescale 1ps/1ps

module tb;

    reg clk;
    reg run_clk;
    reg reset_n;
    reg enable;

    wire red;
    wire yellow;
    wire green;

    integer mismatches;
    integer samples;

    traffic_light_fsm dut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // Clock generation that terminates cleanly
    initial begin
        clk = 0;
        run_clk = 1;

        while (run_clk) begin
            #5;
            clk = ~clk;
        end
    end

    task check_output;
        input integer cycle;
        input exp_red;
        input exp_yellow;
        input exp_green;
        input integer test_case;

        begin
            @(negedge clk);

            samples = samples + 1;

            if ((red !== exp_red) ||
                (yellow !== exp_yellow) ||
                (green !== exp_green)) begin

                mismatches = mismatches + 1;

                $display(
                    "Error: Test case %0d failed after %0d clock cycles. Expected RYG=%b%b%b, Got=%b%b%b",
                    test_case,
                    cycle,
                    exp_red,
                    exp_yellow,
                    exp_green,
                    red,
                    yellow,
                    green
                );
            end
        end
    endtask

    initial begin

        reset_n = 0;
        enable = 1;

        mismatches = 0;
        samples = 0;

        // Test 1: FSM starts in RED
        check_output(
            0,
            1'b1,
            1'b0,
            1'b0,
            1
        );

        // Release reset
        #5 reset_n = 1;

        // Test 2: RED -> GREEN after 32 cycles
        repeat (32)
            @(posedge clk);

        check_output(
            32,
            1'b0,
            1'b0,
            1'b1,
            2
        );

        // Test 3: GREEN -> YELLOW after 20 cycles
        repeat (20)
            @(posedge clk);

        check_output(
            20,
            1'b0,
            1'b1,
            1'b0,
            3
        );

        // Test 4: YELLOW -> RED after 7 cycles
        repeat (7)
            @(posedge clk);

        check_output(
            7,
            1'b1,
            1'b0,
            1'b0,
            4
        );

        run_clk = 0;

        // AutoChip-required final output line
        $display(
            "Mismatches: %0d in %0d samples",
            mismatches,
            samples
        );
    end

endmodule

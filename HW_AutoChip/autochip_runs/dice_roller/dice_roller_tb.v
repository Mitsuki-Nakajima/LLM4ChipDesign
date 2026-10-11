
`timescale 1ns / 1ps

module tb;

    reg clk;
    reg run_clk;
    reg rst_n;
    reg [1:0] die_select;
    reg roll;

    wire [7:0] rolled_number;

    integer i;
    integer j;
    integer mismatches;
    integer samples;

    dice_roller dut (
        .clk(clk),
        .rst_n(rst_n),
        .die_select(die_select),
        .roll(roll),
        .rolled_number(rolled_number)
    );

    initial begin
        clk = 0;
        run_clk = 1;

        while (run_clk) begin
            #5;
            clk = ~clk;
        end
    end

    initial begin

        rst_n = 0;
        die_select = 0;
        roll = 0;

        mismatches = 0;
        samples = 0;

        #10;
        rst_n = 1;

        #10;

        for (i = 0; i < 4; i = i + 1) begin

            die_select = i[1:0];

            for (j = 0; j < 1000; j = j + 1) begin

                roll = 0;
                #10;

                roll = 1;
                #10;

                roll = 0;
                #10;

                samples = samples + 1;

                case (die_select)

                    2'b00: begin
                        if ((rolled_number < 1) ||
                            (rolled_number > 4)) begin

                            mismatches = mismatches + 1;

                            $display(
                                "Invalid d4 result: %0d",
                                rolled_number
                            );
                        end
                    end

                    2'b01: begin
                        if ((rolled_number < 1) ||
                            (rolled_number > 6)) begin

                            mismatches = mismatches + 1;

                            $display(
                                "Invalid d6 result: %0d",
                                rolled_number
                            );
                        end
                    end

                    2'b10: begin
                        if ((rolled_number < 1) ||
                            (rolled_number > 8)) begin

                            mismatches = mismatches + 1;

                            $display(
                                "Invalid d8 result: %0d",
                                rolled_number
                            );
                        end
                    end

                    2'b11: begin
                        if ((rolled_number < 1) ||
                            (rolled_number > 20)) begin

                            mismatches = mismatches + 1;

                            $display(
                                "Invalid d20 result: %0d",
                                rolled_number
                            );
                        end
                    end

                endcase
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

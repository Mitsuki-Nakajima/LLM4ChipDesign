
`timescale 1ns/1ps

module tb;

    reg clk;
    reg run_clk;
    reg rst_n;
    reg A;
    reg B;

    wire O;
    wire [3:0] State;

    integer i;
    integer mismatches;
    integer samples;

    reg expected_O;
    reg [3:0] expected_state;

    abro_state_machine uut (
        .clk(clk),
        .rst_n(rst_n),
        .A(A),
        .B(B),
        .O(O),
        .State(State)
    );

    initial begin
        clk = 0;
        run_clk = 1;

        while (run_clk) begin
            #5;

            if (run_clk)
                clk = ~clk;
        end
    end

    initial begin
        rst_n = 1;
        A = 0;
        B = 0;

        mismatches = 0;
        samples = 0;

        for (i = 0; i < 16; i = i + 1) begin

            case (i)

                0: begin
                    A = 0;
                    B = 0;
                    expected_O = 1'b0;
                    expected_state = 4'b0001;
                end

                1: begin
                    A = 0;
                    B = 1;
                    expected_O = 1'b0;
                    expected_state = 4'b0001;
                end

                2: begin
                    A = 1;
                    B = 0;
                    expected_O = 1'b0;
                    expected_state = 4'b0010;
                end

                3: begin
                    A = 1;
                    B = 1;
                    expected_O = 1'b1;
                    expected_state = 4'b0100;
                end

                default: begin
                    A = (i - 1) % 2;
                    B = ((i - 1) / 2) % 2;

                    expected_O =
                        (A && B) ? 1'b1 : 1'b0;

                    expected_state =
                        (A && !B) ? 4'b0010 :
                        ((!A && B) ? 4'b0001 :
                                      4'b0100);
                end

            endcase

            if (i == 0) begin
                rst_n = 0;

                @(posedge clk);
                #1;

                rst_n = 1;
            end

            @(posedge clk);
            #1;

            samples = samples + 1;

            if ((O !== expected_O) ||
                (State !== expected_state)) begin

                mismatches = mismatches + 1;

                $display(
                    "Error: Test case %0d failed (A=%b, B=%b)",
                    i,
                    A,
                    B
                );

                $display(
                    "  Expected: O=%b, State=%b",
                    expected_O,
                    expected_state
                );

                $display(
                    "  Got: O=%b, State=%b",
                    O,
                    State
                );
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

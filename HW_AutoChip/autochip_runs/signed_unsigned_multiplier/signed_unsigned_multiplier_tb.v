
`timescale 1ns/1ps

module tb;

    reg signed [7:0] a;
    reg [7:0] b;

    wire signed [15:0] p;

    integer ai;
    integer bi;
    integer mismatches;
    integer samples;

    reg signed [15:0] expected;

    signed_unsigned_multiplier dut (
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin

        mismatches = 0;
        samples = 0;

        // Exhaustively test:
        // a = -128 ... 127
        // b = 0 ... 255

        for (ai = -128; ai <= 127; ai = ai + 1) begin

            for (bi = 0; bi <= 255; bi = bi + 1) begin

                a = ai;
                b = bi;

                #1;

                // b must remain positive/unsigned.
                // Prefixing 0 creates a positive 9-bit signed value.
                expected =
                    $signed(a) * $signed({1'b0, b});

                samples = samples + 1;

                if (p !== expected) begin

                    mismatches = mismatches + 1;

                    // Avoid flooding simulation output
                    if (mismatches <= 20) begin
                        $display(
                            "Mismatch: a=%0d b=%0d expected=%0d got=%0d",
                            $signed(a),
                            b,
                            expected,
                            $signed(p)
                        );
                    end

                end
            end
        end

        $display(
            "Mismatches: %0d in %0d samples",
            mismatches,
            samples
        );

    end

endmodule

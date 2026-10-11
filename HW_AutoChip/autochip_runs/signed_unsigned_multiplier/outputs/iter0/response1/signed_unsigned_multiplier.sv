module signed_unsigned_multiplier (
    input wire signed [7:0] a,
    input wire [7:0] b,
    output wire signed [15:0] p
);

    assign p = a * b;

endmodule

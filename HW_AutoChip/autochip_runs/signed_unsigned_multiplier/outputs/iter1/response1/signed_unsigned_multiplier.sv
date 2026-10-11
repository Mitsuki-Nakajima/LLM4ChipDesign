module signed_unsigned_multiplier (
    input wire signed [7:0] a,
    input wire [7:0] b,
    output wire signed [15:0] p
);

    wire signed [15:0] signed_a;
    assign signed_a = a; // Ensure that 'a' is correctly signed for multiplication
    assign p = signed_a * b; // Multiply signed 'a' with unsigned 'b'

endmodule

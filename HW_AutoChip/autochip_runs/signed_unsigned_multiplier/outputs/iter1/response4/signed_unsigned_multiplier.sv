module signed_unsigned_multiplier (
    input wire signed [7:0] a,
    input wire [7:0] b,
    output wire signed [15:0] p
);

    // Implement the multiplication while preserving the signed nature of 'a' and ensuring 'b' is treated as unsigned 
    assign p = $signed(a) * $unsigned(b);

endmodule

I am trying to create a Verilog module that multiplies an 8-bit signed input by an 8-bit unsigned input.

Specifications:

- Input a:
    - 8 bits
    - signed
    - range: -128 to 127

- Input b:
    - 8 bits
    - unsigned
    - range: 0 to 255

- Output p:
    - 16 bits
    - signed
    - p = a * b

The design must correctly preserve the signed value of a while treating b as an unsigned positive value.

Examples:

    a =  5, b = 10  -> p = 50
    a = -5, b = 10  -> p = -50
    a = -128, b = 255 -> p = -32640
    a = 127, b = 255  -> p = 32385

The module should be combinational and synthesizable.

Complete the following module:

module signed_unsigned_multiplier (
    input wire signed [7:0] a,
    input wire [7:0] b,
    output wire signed [15:0] p
);

    // Insert your implementation here

endmodule

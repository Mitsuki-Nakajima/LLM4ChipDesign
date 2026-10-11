
`timescale 1ns/1ps

module tb;

    reg clk;
    reg run_clk;
    reg reset_n;
    reg enable;

    reg [7:0] instruction;
    reg [7:0] in_port;

    wire [3:0] pc;
    wire [7:0] accumulator;
    wire [7:0] out_port;
    wire out_valid;
    wire halted;

    integer mismatches;
    integer samples;

    cpu_8bit dut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .instruction(instruction),
        .in_port(in_port),
        .pc(pc),
        .accumulator(accumulator),
        .out_port(out_port),
        .out_valid(out_valid),
        .halted(halted)
    );


    // --------------------------------------------------
    // Program ROM
    // --------------------------------------------------

    function [7:0] program_word;

        input [3:0] addr;

        begin
            case (addr)

                4'h0: program_word = 8'h13; // LDI 3
                4'h1: program_word = 8'h25; // ADD 5
                4'h2: program_word = 8'h70; // SHL
                4'h3: program_word = 8'h31; // SUB 1
                4'h4: program_word = 8'h6F; // XOR F -> 0
                4'h5: program_word = 8'hE7; // JZ 7

                // This instruction should be skipped
                4'h6: program_word = 8'h1F; // LDI F

                4'h7: program_word = 8'hB0; // IN
                4'h8: program_word = 8'h90; // INC
                4'h9: program_word = 8'hC0; // OUT
                4'hA: program_word = 8'hF0; // HALT

                default:
                    program_word = 8'h00; // NOP

            endcase
        end
    endfunction


    // Instruction memory follows program counter
    always @(*) begin
        instruction = program_word(pc);
    end


    // --------------------------------------------------
    // Clock
    // --------------------------------------------------

    initial begin

        clk = 0;
        run_clk = 1;

        while (run_clk) begin
            #5;
            clk = ~clk;
        end

    end


    // --------------------------------------------------
    // Verification task
    // --------------------------------------------------

    task check_state;

        input [3:0] expected_pc;
        input [7:0] expected_acc;

        begin

            samples = samples + 1;

            if ((pc !== expected_pc) ||
                (accumulator !== expected_acc)) begin

                mismatches = mismatches + 1;

                $display(
                    "Mismatch: expected PC=%h ACC=%h, got PC=%h ACC=%h",
                    expected_pc,
                    expected_acc,
                    pc,
                    accumulator
                );

            end

        end

    endtask


    // --------------------------------------------------
    // Test program
    // --------------------------------------------------

    initial begin

        mismatches = 0;
        samples = 0;

        reset_n = 0;
        enable = 0;

        in_port = 8'h2A;


        // Reset CPU
        @(posedge clk);
        #1;

        check_state(
            4'h0,
            8'h00
        );


        // Release reset
        @(negedge clk);

        reset_n = 1;
        enable = 1;


        // LDI 3
        @(posedge clk);
        #1;

        check_state(
            4'h1,
            8'h03
        );


        // ADD 5 -> 8
        @(posedge clk);
        #1;

        check_state(
            4'h2,
            8'h08
        );


        // SHL -> 16
        @(posedge clk);
        #1;

        check_state(
            4'h3,
            8'h10
        );


        // SUB 1 -> 15
        @(posedge clk);
        #1;

        check_state(
            4'h4,
            8'h0F
        );


        // XOR F -> 0
        @(posedge clk);
        #1;

        check_state(
            4'h5,
            8'h00
        );


        // JZ 7
        @(posedge clk);
        #1;

        check_state(
            4'h7,
            8'h00
        );


        // IN -> 0x2A
        @(posedge clk);
        #1;

        check_state(
            4'h8,
            8'h2A
        );


        // INC -> 0x2B
        @(posedge clk);
        #1;

        check_state(
            4'h9,
            8'h2B
        );


        // OUT
        @(posedge clk);
        #1;

        samples = samples + 1;

        if ((pc !== 4'hA) ||
            (accumulator !== 8'h2B) ||
            (out_port !== 8'h2B) ||
            (out_valid !== 1'b1)) begin

            mismatches = mismatches + 1;

            $display(
                "OUT mismatch: PC=%h ACC=%h OUT=%h VALID=%b",
                pc,
                accumulator,
                out_port,
                out_valid
            );

        end


        // HALT
        @(posedge clk);
        #1;

        samples = samples + 1;

        if ((halted !== 1'b1) ||
            (pc !== 4'hA) ||
            (accumulator !== 8'h2B)) begin

            mismatches = mismatches + 1;

            $display(
                "HALT mismatch: PC=%h ACC=%h HALTED=%b",
                pc,
                accumulator,
                halted
            );

        end


        // One more clock to make sure halted CPU holds state
        @(posedge clk);
        #1;

        samples = samples + 1;

        if ((halted !== 1'b1) ||
            (pc !== 4'hA) ||
            (accumulator !== 8'h2B) ||
            (out_port !== 8'h2B)) begin

            mismatches = mismatches + 1;

            $display(
                "CPU changed state after HALT"
            );

        end


        run_clk = 0;

        $display(
            "Mismatches: %0d in %0d samples",
            mismatches,
            samples
        );

    end

endmodule

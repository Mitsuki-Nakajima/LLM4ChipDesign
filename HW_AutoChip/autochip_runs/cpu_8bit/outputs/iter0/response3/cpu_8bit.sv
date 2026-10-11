module cpu_8bit (
    input wire clk,
    input wire reset_n,
    input wire enable,
    input wire [7:0] instruction,
    input wire [7:0] in_port,

    output reg [3:0] pc,
    output reg [7:0] accumulator,
    output reg [7:0] out_port,
    output reg out_valid,
    output reg halted
);

    // Internal signals
    reg [7:0] opcode;
    reg [3:0] operand;

    // Sequential logic for state updates
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset state
            pc <= 4'b0000;
            accumulator <= 8'b00000000;
            out_port <= 8'b00000000;
            out_valid <= 1'b0;
            halted <= 1'b0;
        end else if (enable && !halted) begin
            // Fetching the opcode and operand from the instruction
            opcode <= instruction[7:4];
            operand <= instruction[3:0];

            // Instruction execution
            case (opcode)
                4'h0: ; // NOP
                4'h1: accumulator <= {4'b0000, operand}; // LDI
                4'h2: accumulator <= accumulator + {4'b0000, operand}; // ADD
                4'h3: accumulator <= accumulator - {4'b0000, operand}; // SUB
                4'h4: accumulator <= accumulator & {4'b0000, operand}; // AND
                4'h5: accumulator <= accumulator | {4'b0000, operand}; // OR
                4'h6: accumulator <= accumulator ^ {4'b0000, operand}; // XOR
                4'h7: accumulator <= accumulator << 1; // SHL
                4'h8: accumulator <= accumulator >> 1; // SHR
                4'h9: accumulator <= accumulator + 1; // INC
                4'hA: accumulator <= accumulator - 1; // DEC
                4'hB: accumulator <= in_port; // IN
                4'hC: begin // OUT
                    out_port <= accumulator;
                    out_valid <= 1'b1;
                end
                4'hD: pc <= operand; // JMP
                4'hE: pc <= (accumulator == 8'b00000000) ? operand : (pc + 1); // JZ
                4'hF: halted <= 1'b1; // HALT
                default: pc <= pc + 1; // Increment PC for all other instructions
            endcase
            
            // Advance PC for executed instructions except JMP, JZ when taken, and HALT
            if (opcode != 4'hD && opcode != 4'hE && opcode != 4'hF) begin
                pc <= pc + 1;
            end
        end
    end

    // Pulse out_valid for one clock cycle
    always @(posedge clk) begin
        if (out_valid) begin
            out_valid <= 1'b0;
        end
    end

endmodule

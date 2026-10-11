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

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            pc <= 4'b0000;
            accumulator <= 8'b00000000;
            out_port <= 8'b00000000;
            out_valid <= 1'b0;
            halted <= 1'b0;
        end else if (enable && !halted) begin
            case (instruction[7:4])
                4'h0: begin // NOP
                    // No operation
                end
                4'h1: begin // LDI imm4
                    accumulator <= {4'b0000, instruction[3:0]};
                    pc <= pc + 1'b1;
                end
                4'h2: begin // ADD imm4
                    accumulator <= accumulator + {4'b0000, instruction[3:0]};
                    pc <= pc + 1'b1;
                end
                4'h3: begin // SUB imm4
                    accumulator <= accumulator - {4'b0000, instruction[3:0]};
                    pc <= pc + 1'b1;
                end
                4'h4: begin // AND imm4
                    accumulator <= accumulator & {4'b0000, instruction[3:0]};
                    pc <= pc + 1'b1;
                end
                4'h5: begin // OR imm4
                    accumulator <= accumulator | {4'b0000, instruction[3:0]};
                    pc <= pc + 1'b1;
                end
                4'h6: begin // XOR imm4
                    accumulator <= accumulator ^ {4'b0000, instruction[3:0]};
                    pc <= pc + 1'b1;
                end
                4'h7: begin // SHL
                    accumulator <= accumulator << 1;
                    pc <= pc + 1'b1;
                end
                4'h8: begin // SHR
                    accumulator <= accumulator >> 1;
                    pc <= pc + 1'b1;
                end
                4'h9: begin // INC
                    accumulator <= accumulator + 1'b1;
                    pc <= pc + 1'b1;
                end
                4'hA: begin // DEC
                    accumulator <= accumulator - 1'b1;
                    pc <= pc + 1'b1;
                end
                4'hB: begin // IN
                    accumulator <= in_port;
                    pc <= pc + 1'b1;
                end
                4'hC: begin // OUT
                    out_port <= accumulator;
                    out_valid <= 1'b1;
                    pc <= pc + 1'b1;
                end
                4'hD: begin // JMP addr4
                    pc <= instruction[3:0];
                end
                4'hE: begin // JZ addr4
                    if (accumulator == 8'b00000000) begin
                        pc <= instruction[3:0];
                    end else begin
                        pc <= pc + 1'b1;
                    end
                end
                4'hF: begin // HALT
                    halted <= 1'b1;
                end
                default: begin
                    pc <= pc + 1'b1;
                end
            endcase

            if (instruction[7:4] == 4'hC) begin
                out_valid <= 1'b0; // pulse out_valid low after this cycle
            end
        end
    end
endmodule

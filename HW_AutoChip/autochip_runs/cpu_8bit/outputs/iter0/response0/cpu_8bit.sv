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
    
    // Instruction opcodes
    localparam NOP  = 4'h0;
    localparam LDI  = 4'h1;
    localparam ADD  = 4'h2;
    localparam SUB  = 4'h3;
    localparam AND  = 4'h4;
    localparam OR   = 4'h5;
    localparam XOR  = 4'h6;
    localparam SHL  = 4'h7;
    localparam SHR  = 4'h8;
    localparam INC  = 4'h9;
    localparam DEC  = 4'hA;
    localparam IN   = 4'hB;
    localparam OUT  = 4'hC;
    localparam JMP  = 4'hD;
    localparam JZ   = 4'hE;
    localparam HALT = 4'hF;

    // Sequential logic for state transitions
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            pc <= 4'd0;
            accumulator <= 8'd0;
            out_port <= 8'd0;
            out_valid <= 1'b0;
            halted <= 1'b0;
        end else if (enable && !halted) begin
            out_valid <= 1'b0; // Reset out_valid on each cycle
            case (instruction[7:4])
                NOP: begin
                    // Do nothing (pc will advance)
                end
                LDI: begin
                    accumulator <= {4'b0000, instruction[3:0]};
                end
                ADD: begin
                    accumulator <= accumulator + {4'b0000, instruction[3:0]};
                end
                SUB: begin
                    accumulator <= accumulator - {4'b0000, instruction[3:0]};
                end
                AND: begin
                    accumulator <= accumulator & {4'b0000, instruction[3:0]};
                end
                OR: begin
                    accumulator <= accumulator | {4'b0000, instruction[3:0]};
                end
                XOR: begin
                    accumulator <= accumulator ^ {4'b0000, instruction[3:0]};
                end
                SHL: begin
                    accumulator <= accumulator << 1;
                end
                SHR: begin
                    accumulator <= accumulator >> 1;
                end
                INC: begin
                    accumulator <= accumulator + 1;
                end
                DEC: begin
                    accumulator <= accumulator - 1;
                end
                IN: begin
                    accumulator <= in_port;
                end
                OUT: begin
                    out_port <= accumulator;
                    out_valid <= 1'b1; // Pulse out_valid high
                end
                JMP: begin
                    pc <= instruction[3:0];
                end
                JZ: begin
                    if (accumulator == 8'd0) begin
                        pc <= instruction[3:0];
                    end else begin
                        pc <= pc + 1;
                    end
                end
                HALT: begin
                    halted <= 1'b1; // Set halted state
                end
                default: begin
                    // No operation for unhandled opcodes
                end
            endcase
            
            if (instruction[7:4] != JMP && instruction[7:4] != JZ && instruction[7:4] != HALT) begin
                pc <= pc + 1; // Advance program counter for all instructions except control flow
            end
        end
    end

endmodule

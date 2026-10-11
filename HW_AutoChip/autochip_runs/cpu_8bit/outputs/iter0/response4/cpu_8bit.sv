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
    
    // State initialization
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            pc <= 4'd0;
            accumulator <= 8'd0;
            out_port <= 8'd0;
            out_valid <= 1'b0;
            halted <= 1'b0;
        end else if (enable && !halted) begin
            out_valid <= 1'b0; // Default to low
            
            case (instruction[7:4]) 
                4'h0: ; // NOP
                4'h1: accumulator <= {4'b0000, instruction[3:0]}; // LDI
                4'h2: accumulator <= accumulator + {4'b0000, instruction[3:0]}; // ADD
                4'h3: accumulator <= accumulator - {4'b0000, instruction[3:0]}; // SUB
                4'h4: accumulator <= accumulator & {4'b0000, instruction[3:0]}; // AND
                4'h5: accumulator <= accumulator | {4'b0000, instruction[3:0]}; // OR
                4'h6: accumulator <= accumulator ^ {4'b0000, instruction[3:0]}; // XOR
                4'h7: accumulator <= accumulator << 1; // SHL
                4'h8: accumulator <= accumulator >> 1; // SHR
                4'h9: accumulator <= accumulator + 1; // INC
                4'hA: accumulator <= accumulator - 1; // DEC
                4'hB: accumulator <= in_port; // IN
                4'hC: begin // OUT
                    out_port <= accumulator;
                    out_valid <= 1'b1; // Pulse out_valid
                end
                4'hD: pc <= instruction[3:0]; // JMP
                4'hE: begin // JZ
                    if (accumulator == 8'd0)
                        pc <= instruction[3:0];
                    else
                        pc <= pc + 1;
                end
                4'hF: halted <= 1'b1; // HALT
            endcase
            
            // Increment PC for all operations except jumps or halt
            if (instruction[7:4] != 4'hD && instruction[7:4] != 4'hE && instruction[7:4] != 4'hF) begin
                pc <= pc + 1;
            end
        end
    end
    
endmodule

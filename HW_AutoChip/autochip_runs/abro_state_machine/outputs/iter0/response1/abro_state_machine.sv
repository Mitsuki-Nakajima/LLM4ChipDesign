module abro_state_machine (
    input wire clk,
    input wire rst_n,
    input wire A,
    input wire B,
    output reg O,
    output reg [3:0] State
);

    // State encoding
    parameter S0 = 4'b0001;
    parameter S1 = 4'b0010;
    parameter S2 = 4'b0100;
    parameter S3 = 4'b1000;

    // Current state and next state
    reg [3:0] current_state, next_state;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;
            O <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // State logic
    always @(*) begin
        case (current_state)
            S0: begin
                O = 0;
                if (A) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                O = 1;
                if (B) next_state = S2;
                else next_state = S1;
            end
            S2: begin
                O = 1;
                next_state = S3;
            end
            S3: begin
                O = 0;
                next_state = S0;
            end
            default: begin
                O = 0;
                next_state = S0;
            end
        endcase
    end

    // Output current state
    assign State = current_state;

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 08:45:37 AM
// Design Name: 
// Module Name: project_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CLA_Adder (
    input [7:0] A,          // First operand
    input [7:0] B,          // Second operand
    input Cin,              // Carry input (for multi-bit operations)
    output [7:0] Sum,       // Sum result
    output Cout,            // Carry output (for multi-bit operations)
    input enable            // Enable signal for clock gating (power optimization)
);
    wire [7:0] G, P;       // Generate and Propagate signals
    wire [8:0] C;          // Carry signals

    // Generate and Propagate
    assign G = A & B;      // Generate: G[i] = A[i] & B[i]
    assign P = A | B;      // Propagate: P[i] = A[i] | B[i]

    // Carry Look-Ahead Logic (Power-gated)
    assign C[0] = Cin;     // Carry in for the first bit
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]); // Final carry out

    // Sum Calculation with enable control
    assign Sum = enable ? (A ^ B ^ C[7:0]) : 8'b0;   // Sum = A ⊕ B ⊕ carry, or 0 if disabled

    // Carry out with enable control
    assign Cout = enable ? C[8] : 1'b0;  // Carry out or 0 if disabled

endmodule

module project_1 (
    input [7:0] A,          // First operand
    input [7:0] B,          // Second operand
    input [2:0] ALUOp,      // Operation select signal (3 bits for 8 operations)
    input clk,              // Clock input
    input reset,            // Reset input
    input enable,           // Enable signal for clock gating
    output reg [7:0] result,// ALU result
    output reg zero,        // Zero flag
    output reg overflow     // Overflow flag
);

// Define operation codes
localparam ADD  = 3'b000; 
localparam SUB  = 3'b001;
localparam AND  = 3'b010;
localparam OR   = 3'b011;
localparam XOR  = 3'b100;
localparam CMP  = 3'b101; // Comparison operation: A == B
localparam NAND = 3'b110;
localparam NOR  = 3'b111;

// Internal signals for CLA adder
wire [7:0] sum;          // Sum result from CLA Adder
wire carry_out;          // Carry output from CLA Adder
reg temp_overflow;       // Temporary overflow flag

// CLA Adder instance for ADD and SUB operations
CLA_Adder cla_adder (
    .A(A),
    .B(B),
    .Cin(1'b0),         // No initial carry for addition
    .Sum(sum),
    .Cout(carry_out),
    .enable(enable)      // Power gate CLA Adder based on enable signal
);

// ALU operation logic with clock gating, reset, and overflow detection
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all outputs on reset signal
        result <= 8'b0;
        zero <= 1'b0;
        overflow <= 1'b0;
    end else if (enable) begin
        // Perform ALU operation based on ALUOp
        case(ALUOp)
            ADD: begin
                result = sum;
                // Detect overflow for addition (signed)
                temp_overflow = (A[7] == B[7]) && (sum[7] != A[7]);
                overflow = temp_overflow;
            end
            SUB: begin
                result = A - B;
                // Detect overflow for subtraction (signed)
                temp_overflow = (A[7] != B[7]) && (result[7] != A[7]);
                overflow = temp_overflow;
            end
            AND:   result = A & B;   // Bitwise AND
            OR:    result = A | B;   // Bitwise OR
            XOR:   result = A ^ B;   // Bitwise XOR
            CMP:   result = (A == B) ? 8'b1 : 8'b0; // Comparison: A == B
            NAND:  result = ~(A & B); // Bitwise NAND
            NOR:   result = ~(A | B); // Bitwise NOR
            default: result = 8'b0;   // Default case
        endcase

        // Set the zero flag
        zero = (result == 8'b0) ? 1'b1 : 1'b0;

    end
end

endmodule




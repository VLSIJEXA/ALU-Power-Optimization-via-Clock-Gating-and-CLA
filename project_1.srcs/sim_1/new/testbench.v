`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 08:47:44 AM
// Design Name: 
// Module Name: testbench
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


module testbench;

   

    // Inputs
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] ALUOp;
    reg clk;
    reg reset;
    reg enable;

    // Outputs
    wire [7:0] result;
    wire zero;
    wire overflow;

    // Instantiate the ALU
   project_1 uut (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .result(result),
        .zero(zero),
        .overflow(overflow)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        A = 8'b0;
        B = 8'b0;
        ALUOp = 3'b0;
        reset = 1;
        enable = 0;

        // Reset the ALU
        #10 reset = 0;
        enable = 1;

        // Test ADD operation
        #10 A = 8'b00000101; // 5
             B = 8'b00000011; // 3
             ALUOp = 3'b000; // ADD
        #10 $display("ADD: A=%d, B=%d, Result=%d, Zero=%b, Overflow=%b", A, B, result, zero, overflow);

        // Test SUB operation
        #10 ALUOp = 3'b001; // SUB
        #10 $display("SUB: A=%d, B=%d, Result=%d, Zero=%b, Overflow=%b", A, B, result, zero, overflow);

        // Test AND operation
        #10 ALUOp = 3'b010; // AND
        #10 $display("AND: A=%b, B=%b, Result=%b, Zero=%b, Overflow=%b", A, B, result, zero, overflow);

        // Test OR operation
        #10 ALUOp = 3'b011; // OR
        #10 $display("OR: A=%b, B=%b, Result=%b, Zero=%b, Overflow=%b", A, B, result, zero, overflow);

        // Test XOR operation
        #10 ALUOp = 3'b100; // XOR
        #10 $display("XOR: A=%b, B=%b, Result=%b, Zero=%b, Overflow=%b", A, B, result, zero, overflow);

        // Test CMP operation
        #10 A = 8'b00000011; // 3
             B = 8'b00000011; // 3
             ALUOp = 3'b101; // CMP
        #10 $display("CMP: A=%d, B=%d, Result=%b, Zero=%b, Overflow=%b", A, B, result, zero, overflow);

        // Test NAND operation
        #10 ALUOp = 3'b110; // NAND
        #10 $display("NAND: A=%b, B=%b, Result=%b, Zero=%b, Overflow=%b", A, B, result, zero, overflow);

        // Test NOR operation
        #10 ALUOp = 3'b111; // NOR
        #10 $display("NOR: A=%b, B=%b, Result=%b, Zero=%b, Overflow=%b", A, B, result, zero, overflow);

        // Finish simulation
        #20 $stop;
    end

endmodule


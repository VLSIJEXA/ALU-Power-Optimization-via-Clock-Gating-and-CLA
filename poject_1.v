`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// JATIN KATIYAR MNIT JAIPUR
// Create Date: 11/18/2024 08:45:37 AM
// Design Name: 
// Module Name: project_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CLA_Adder_32bit (
    input [31:0] A, B,
    input Cin,
    output [31:0] Sum,
    output Cout
);
    wire [31:0] G, P, C;

    
    assign G = A & B;
    assign P = A ^ B;

    assign C[0] = Cin;
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : carry_gen
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate
    assign Cout = G[31] | (P[31] & C[31]);

  
    assign Sum = P ^ C;
endmodule
module ALU_32bit (
    input [31:0] A, B,
    input [2:0] Opcode,
    input Clk, Enable,
    output reg [31:0] Result,
    output reg Cout
);
    wire [31:0] CLA_Sum;
    wire CLA_Cout;
    reg Clk_Gated;
    reg [31:0] B_comp; 
    always @(*) begin
        if (Enable)
            Clk_Gated = Clk;
        else
            Clk_Gated = 0;
    end

    
    always @(*) begin
        if (Opcode == 3'b001) 
            B_comp = ~B + 1; 
        else
            B_comp = B; 
    end

  
    CLA_Adder_32bit CLA (
        .A(A),
        .B(B_comp), 
        .Cin(Opcode == 3'b001 ? 0 : 0), 
        .Sum(CLA_Sum),
        .Cout(CLA_Cout)
    );

   
    always @(posedge Clk_Gated) begin
        case (Opcode)
            3'b000: begin
                Result = CLA_Sum; 
                Cout = CLA_Cout;
            end
            3'b001: begin
                if (CLA_Cout == 1'b0) begin
                    Result = ~CLA_Sum + 1;
                    Cout = ~CLA_Cout;
                end
                else begin
                    Result = CLA_Sum;
                    Cout = ~CLA_Cout; 
                end
            end
            3'b010: Result = A & B;          
            3'b011: Result = A | B;         
            3'b100: Result = A ^ B;         
            3'b101: Result = ~A;             
            default: Result = 32'b0;         
        endcase
    end
endmodule
///////////////////////////////////////////////////
//testbench
   `timescale 1ns / 1ps

module ALU_32bit_tb;

    reg [31:0] A, B;
    reg [2:0] Opcode;
    reg Clk, Enable; 
    wire [31:0] Result;
    wire Cout;

    
    ALU_32bit uut (
        .A(A),
        .B(B),
        .Opcode(Opcode),
        .Clk(Clk),
        .Enable(Enable),
        .Result(Result),
        .Cout(Cout)
    );

    
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk; 
    end

   
    initial begin
        
        Enable = 1;

        
        Opcode = 3'b000;
        A = 32'h0000_0005;
        B = 32'h0000_0003;
        #10; 
        $display("Addition: A = %h, B = %h, Result = %h, Cout = %b", A, B, Result, Cout);

        
        Opcode = 3'b001;
        A = 32'h0000_0008;
        B = 32'h0000_0003;
        #10;
        $display("Subtraction: A = %h, B = %h, Result = %h, Cout = %b", A, B, Result, Cout);

        
        Opcode = 3'b010;
        A = 32'h0000_00FF;
        B = 32'h0000_0F0F;
        #10;
        $display("AND: A = %h, B = %h, Result = %h", A, B, Result);

        
        Opcode = 3'b011;
        A = 32'h0000_00FF;
        B = 32'h0000_0F0F;
        #10;
        $display("OR: A = %h, B = %h, Result = %h", A, B, Result);

        
        Opcode = 3'b100;
        A = 32'h0000_00FF;
        B = 32'h0000_0F0F;
        #10;
        $display("XOR: A = %h, B = %h, Result = %h", A, B, Result);

        
        Opcode = 3'b101;
        A = 32'h0000_00FF;
        #10;
        $display("NOT: A = %h, Result = %h", A, Result);

       
        Enable = 0;
        Opcode = 3'b000;
        A = 32'h0000_0005;
        B = 32'h0000_0003;
        #10;
        $display("Disabled ALU: A = %h, B = %h, Result = %h, Cout = %b", A, B, Result, Cout);

        
        $stop;
    end

endmodule
  

          



   
           

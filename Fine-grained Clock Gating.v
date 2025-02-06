Clock gating is the process of disabling the clock signal to certain parts of the circuit when they aren't actively processing data. 
This is usually done by inserting a logic gate (like an AND gate) in the clock path, where the clock signal is gated by an enable signal.
If the enable signal is off, the clock signal won't reach the component, effectively halting its operation.

module clock_gated_ff (
    input wire clk,        
    input wire enable,     
    input wire reset,      
    input wire d,         
    output reg q          
);
 wire gated_clk;
     assign gated_clk = clk & enable;  
    always @(posedge gated_clk or posedge reset) begin
        if (reset) begin
            q <= 0;  
        end else begin
            q <= d; 
        end
    end
  endmodule


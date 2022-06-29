`timescale 1ns / 1ps
module tb_multiplier_hp16();
reg [15:0]A;
wire [15:0]P;
multiplier_hp16 uut(.mul_in_A(A),.mul_in_B(A),.Product(P));
initial
begin
    $dumpvars;
    A=16'b1011111010011010;
    $monitor("A=%b,P=%b",A,P);
    #0.01   A=16'b0011001001100110; 
    $monitor("A=%b,P=%b",A,P);
    #0.01   A=16'b0010001000100101;  
    $monitor("A=%b,P=%b",A,P);
    #0.01   A=16'b0000000000000000;  
    $monitor("A=%b,P=%b",A,P);
    #0.01   A=16'b1100010010000000;  
    $monitor("A=%b,P=%b",A,P);
    #0.01   A=16'b1011011000001100;  
    $monitor("A=%b,P=%b",A,P);
    
end
endmodule
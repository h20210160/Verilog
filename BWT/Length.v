`timescale 1ns / 1ps
module Length(clk,reset,din,CS,len_str,addr,ren,wen);
parameter len_addr = 10, len_str_max = 1024;
input clk,reset,CS;
input [7:0]din;
output reg [len_addr-1:0]len_str;
output reg ren,wen; 
output reg [len_addr-1:0]addr;
always @(posedge reset) 
    begin
        addr=10'd0;
    end
always @(posedge (clk && !reset && CS))    
    begin
        wen=1'b0; ren=1'b1;
        if(din==8'd36)
        begin
        len_str=addr+1'b1;
        ren=1'b0;
        end 
        else
        addr=addr+1'b1;
    end
endmodule

`timescale 1ns / 1ps

module memory(clk,wen,ren,dout,addr,addr1,din);
parameter len_str = 1024,max_len_str = 1024;
input ren,wen,clk;
input [7:0]din;
output reg [7:0]dout;
input [9:0]addr,addr1;
reg [7:0]storage[len_str-1:0];
reg [7:0]bwt_arr[max_len_str-1:0];
always @(clk)
    begin
        if(ren) dout=storage[addr];
        if(wen) bwt_arr[addr1]=din;
    end
endmodule

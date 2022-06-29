`timescale 1ns / 1ps
module Top_module(clk,clk_out,din,dout,CS_bwt,CS_ibwt,ren,wen,addr,CS_len,rst_len,ren1,rst_bwt,len1,ren_bwt,wen_bwt,
                    len_str,start,flag_bwt,flag_ibwt,dout_bwt,addr_len,ren_len,wen_len,din_bwt,addr1,addr_bwt,addr1_bwt);
parameter s0=3'd0,s1=3'd1,s2=3'd2,s3=3'd3,s4=3'd4,len_addr = 10;
input [7:0]din,din_bwt;
input start,flag_bwt,flag_ibwt,clk,ren_len,wen_len,ren_bwt,wen_bwt;
output reg [7:0]dout,dout_bwt;
output reg CS_bwt,CS_ibwt,CS_len,ren,wen,rst_len,clk_out,rst_bwt;
output ren1;
output [9:0]addr_len;
input [9:0]addr_bwt,addr1_bwt;
output reg [9:0]addr,addr1;
reg [2:0]state;
input [len_addr-1:0]len_str;
output reg [len_addr-1:0]len1;
always @ (clk) clk_out=clk;
memory mem1(.clk(clk_out),.wen(wen),.ren(ren),.dout(din),.addr(addr),.addr1(addr1),.din(dout));
Length len_inst(.clk(clk_out),.reset(rst_len),.din(dout),.CS(CS_len),.len_str(len_str),.addr(addr_len),.ren(ren_len),.wen(wen_len));
BWT1 BWT_inst(.clk(clk_out),.ren(ren_bwt),.wen(wen_bwt),.flag(flag_bwt),.CS(CS_bwt),.din(dout_bwt),.len_str(len1),.dout(din_bwt),.addr(addr_bwt),.addr1(addr1_bwt),.reset(rst_bwt));
//IBWT ibwt(.clk(clk),.flag(flag_ibwt),.CS(CS_ibwt));
always @(clk)
    begin
        case(state)
        s0: begin rst_len=1'd1; rst_bwt=1'd1; state=s1; end
        s1: begin rst_len=1'd0; CS_len=1'd1; CS_bwt=1'd0; CS_ibwt=1'd0; addr=addr_len;wen=wen_len;ren=ren_len; dout=din;len1=len_str; if(!ren) state=s2; end
        s2: begin rst_bwt=1'd0; CS_len=1'd0; CS_bwt=1'd1; CS_ibwt=1'd0; dout_bwt=din;wen=wen_bwt;ren=ren_bwt;dout=din_bwt;addr1=addr1_bwt;addr=addr_bwt; if(flag_bwt) begin CS_bwt=1'd0; state=s3; end end
        s3: begin CS_len=1'd0; CS_bwt=1'd0; CS_ibwt=1'd1; if(flag_ibwt) state=s4; end
        s4: state=s4;
        default: state=s0;
        endcase
    end 

endmodule

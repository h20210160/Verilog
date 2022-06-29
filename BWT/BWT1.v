`timescale 1ns / 1ps
module BWT1(clk,reset,flag,CS,len_str,din,dout,addr,addr1,ren,wen);
parameter len_addr = 10,max_len_str = 1024;
parameter s0=4'd0,s1=4'd1,s2=4'd2,s3=4'd3,s4=4'd4,s5=4'd5,s6=4'd6,s7=4'd7,s8=4'd8,s9=4'd9;
input clk,CS,reset;
input [7:0]din;
output reg flag;
output reg [7:0]dout;

reg [3:0]state;
output reg ren,wen; 
reg [7:0]A,B;

output reg [len_addr-1:0]addr,addr1;
input [len_addr-1:0]len_str;
reg [len_addr-1:0]count,count1;
reg [len_addr-1:0]suf_arr[max_len_str-1:0];
integer i,j,k,p,tmp_p,tmp_k;
always @(reset) state=s0;
always @(posedge (clk&&CS&&(!reset)))
    begin
    case(state)
    s0:begin 
            for(i=0;i<len_str;i=i+1) suf_arr[i]=i;
            count=len_str-1'b1;
            i=0;
            state=s1;
       end
    s1:begin
            if(i<count)
            begin
            count1=count-i;
            j=0;
            state=s2;
            end
            else
            begin
            i=0;
            state=s8;
            end
        end
    s2:begin
            if(j<count1)
            begin
            ren=1'b1; wen=1'b0;
            k=suf_arr[j];
            addr=k;
            tmp_k=k;
            state=s3;
            end
            else
            begin
            i=i+1;
            state=s1;
            end   
       end
    s3:begin
            A=din;
            p=suf_arr[j+1];
            tmp_p=p;
            addr=p;
            state=s4;
       end
    s4:begin
            B=din;
            if(A==B) state=s5;
            else state=s7;                    
       end
    s5:begin
            tmp_k=tmp_k+1'b1;
            addr=tmp_k;
            state=s6;
       end
    s6:begin
            A=din;
            tmp_p=tmp_p+1'b1;
            addr=tmp_p;
            state=s4;
       end
    s7:begin
            if(A>B)
            begin
            tmp_p=p;
            p=k;
            k=tmp_p;
            suf_arr[j]=k;
            suf_arr[j+1]=p;
            end  
            j=j+1'b1;
            state=s2; 
        end
    s8:begin
            if(i<len_str)
            begin
                if(suf_arr[i]) k=suf_arr[i]-1'b1;
                else k=len_str-1;
                addr=k; 
                addr1=i;
                state=s9;
            end
            else flag=1;
        end
     s9:begin
            ren=1'b1; wen=1'b1;
            dout=din;
            i=i+1;
            state=s8;       
        end
    default: state=s0;
    endcase
    end
endmodule

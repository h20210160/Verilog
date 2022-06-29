`timescale 1ns / 1ps
module text_read(clk,ren,wen);
parameter len_addr = 10, len_str = 1024;
output reg clk,ren,wen; 
reg [7:0]din;
wire [7:0]dout;
reg [len_addr-1:0]addr;
integer Rfile,i;
initial clk=1'b0;
always  #0.1 clk=~clk;
Top_module TM(.clk(clk));
initial    
    begin
    Rfile=$fopen("Rfile.txt","r");
    i=0;
    while(!$feof(Rfile))
        begin
        $fscanf(Rfile,"%c",din); 
        TM.mem1.storage[i]=din;
        i=i+1;
        end   
        //TM.mem1.storage[i]=din;
    end
endmodule
// Inturi Sarath Chandra -  2021H1400160P
// Arpit Shukla -  2021H1400166P
// Mayank -  2021H1400154P
// Urvi Barapatre -  2021H1400161P

`timescale 1ns / 1ps
module multiplier_hp16(mul_in_A,mul_in_B,Product);
	input [15:0]mul_in_A,mul_in_B;
	output [15:0]Product;
	reg [10:0]product;
	reg [4:0]Exp;
	reg [12:0]M;
	reg [12:0]M1;
	reg [2:0]a[5:0];
    reg signed [22:0]part_prod;
    reg [21:0]prod,part_prod2;
    reg [3:0]shftL;
	integer i,j;
	always @(*)
	begin
	      Exp={1'b0,mul_in_A[14:10]};
          M={1'b0,1'b1,mul_in_A[9:0],1'b0};
          M1=(M[11:1]<<1);
          for(i=0;i<11;i=i+2)
          a[(i/2)]={M[i+2],M[i+1],M[i]};
          j=1;
    end
	always @(posedge j)
    begin
        if((Exp==5'd0)&&(M[10:1]==10'd0)) 
                begin
                    Exp=5'd0;
                    product=11'd0;
                    j=0;
                end
        else
        begin
        for(i=0;i<6;i=i+1)
	    begin :pp
		  case (a[i])
		      3'b000:part_prod=23'b0;
		      3'b001:begin
		              part_prod={M[12:1],11'd0};
		              part_prod=part_prod>>>11;
		             end
		      3'b010:begin
		              part_prod={M[12:1],11'd0};
		              part_prod=part_prod>>>11;
		             end
		      3'b011:begin
		              part_prod={M1,10'd0};
		              part_prod=part_prod>>>10;
		             end
		      3'b100:begin
		              part_prod={((~M1)+11'b1),10'd0};
		              part_prod=part_prod>>>10;
		             end
		      3'b101:begin
		              part_prod={(~(M[12:1])+1'b1),11'd0};
		              part_prod=part_prod>>>11;
		             end
		      3'b110:begin
		              part_prod={(~(M[12:1])+1'b1),11'd0};
		              part_prod=part_prod>>>11;
		             end
		      3'b111:part_prod=23'b0;
		      default:part_prod=23'bz;
		  endcase
		  if(i==0)
		  begin
		      shftL=4'b0;
		      prod=part_prod;
		  end
		  if(i>0)
		  begin
		      shftL=(shftL+4'b10);
		      part_prod2=part_prod<<shftL;
		      prod=prod + part_prod2;
          end
    end
    if((prod[11:9])>(3'b110))
		     prod[21:11]=prod[21:11]+11'b001;
    if(Exp<5'd8)
    begin
        Exp=5'd1;
    end  
    else 
        if(Exp>5'd22)
        begin
            Exp=5'd30;
            prod=22'h3fffff;
        end
        else begin
                Exp=(Exp<<1);
                if(prod[21:20]<2'b10) 
                    begin
                        Exp=Exp+5'b10001;
                        product=prod[20:10];
                    end	    
                else
                    begin
                        Exp=Exp+5'b10010;	
                        product=prod[21:11];
                    end
              end
    j=0;
    end
    end
    assign Product={1'b0,Exp,product[9:0]};
endmodule
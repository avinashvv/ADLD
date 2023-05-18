`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:37 04/19/2023 
// Design Name: 
// Module Name:    booth 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module booth(a,b,c,rst,clk);
input [3:0]a,b;
input rst,clk;
output reg [7:0]c;
reg [1:0] q[0:3];
reg [3:0]shiftA;
reg [7:0]shiftB,sum1,sum2;
integer i,j;
parameter start=2'b00,rmulti=2'b01,operation=2'b10,stop=2'b11;
reg [1:0]state,nstate;
reg [7:0]mem[0:10];
reg [7:0] u,v,x,y,z;
reg carry,flag ;

reg w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13;

always @(posedge clk or posedge rst)
begin
  if(rst)
  begin
  state<=start;
  end
else
 begin
  state<=nstate;
 end
end

initial begin
for(j=0;j<=10;j=j+1)
begin
mem[j]=0;
end
end


always @(*)
begin
case(state)
start: begin
          c=0;
			 force flag=0;
          sum1=0;
			 sum2=0;
          if(b[0]==0)
          begin			 
			 q[0]=0;
			 end
			 else
			 begin
			 q[0]=2;
			 end
         for(i=1;i<4;i=i+1)
			begin
			case({b[i],b[i-1]})
			2'b00,2'b11 :q[i]=0;
			2'b01       :q[i]=1;
			2'b10       :q[i]=2;
			default     :q[i]=2'bxx;
			endcase
			end
		
			nstate=rmulti;
		 end
rmulti:begin
         for(i=0;i<4;i=i+1)
			 begin
			 case(q[i])
		    2'b00,2'b11 :shiftA[3:0]=4'b0000;
		    2'b01       :shiftA=a;
		    2'b10       :shiftA=~a+1;
			 default     :shiftA=2'bxx;
		  	 endcase
			  shiftB={shiftA[3],shiftA[3],shiftA[3],shiftA[3],shiftA};
			  mem[i]=shiftB<<i;
			 end
			 nstate=operation;
			
		 end
operation:begin
             u=mem[0];
				 v=mem[1];
				 x=mem[2];
				 y=mem[3];
			    //c=u+v+x+y;
				 ppadder(u,v,0,sum1,w11);
				 ppadder(y,x,0,sum2,w12);
				 //w13=w11|w12;
				 ppadder(sum2,sum1,0,c,carry);
				 z=~c+1'b1;
				 nstate=operation;
		    end
default:begin
         mem[7]=8'd0;
         nstate=start;
		  end
endcase		


end


task ppadder;
input[7:0]a,b;
input c;
output[7:0]s;
output cout;
begin

fadd(a[0],b[0],c,s[0],w1);
fadd(a[1],b[1],w1,s[1],w2);
fadd(a[2],b[2],w2,s[2],w3);
fadd(a[3],b[3],w3,s[3],w4);
fadd(a[4],b[4],w4,s[4],w5);
fadd(a[5],b[5],w5,s[5],w6);
fadd(a[6],b[6],w6,s[6],w7);
fadd(a[7],b[7],w7,s[7],cout);
end
endtask
	
task fadd;
input a,b,cin;
output sum,cout;
begin
halfadder(a,b,w9,w8);
halfadder(w9,cin,sum,w10);
cout=w10|w8;	
end
endtask


task halfadder;
input a,b;
output s,c;
begin
s=a^b;
c=a&b;
end
endtask	
endmodule

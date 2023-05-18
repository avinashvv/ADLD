module regg_test;

wire [15:0]f;
reg [3:0] r1,r2,rd,func;
reg [7:0]addr;
reg clk1,clk2;

integer k;

regg_ex myregg(r1,r2,rd,func,addr,clk1,clk2,f);



initial 
begin
clk1=0;clk2=0;
repeat (20)
begin 
#5 clk1=1; #5 clk1=0;

#5 clk2=1; #5 clk2=0;

end
end

initial 
for (k=0;k<=10;k=k+1)
myregg.regbank[k]=k;


initial
begin

#5 r1=3;  r2=5;  rd=10;   func=0;  addr=125; 
#20 r1=7;  r2=5;  rd=12;   func=1;  addr=127; 
#20 r1=8;  r2=5;  rd=11;   func=2;  addr=128; 
#20 r1=3;  r2=5;  rd=13;   func=3;  addr=129; 
#20 r1=3;  r2=5;  rd=14;   func=4;  addr=130; 


#60 for(k=125;k<131;k=k+1)
  $display("mem[%3d] = %3d",k,myregg.mem[k]);
end


initial
begin
 $dumpfile("regg_ex.vod");
 $dumpvars(0,regg_test);
 $monitor ("Time:%3d, f=%3d",$time,f);
 #300 $finish;
end

endmodule


module regg_ex(r1,r2,rd,func,addr,clk1,clk2,f);

input [3:0]func;
input [3:0] r1,r2,rd;
input clk1,clk2;
input [7:0]addr;

output [15:0]f;

reg [15:0] a,b,z_l12,z_l31;
reg [3:0] fun_l12,rd_l12,rd_l21;
reg [7:0] addr_l12,addr_l21,addr_l31;

reg [15:0] regbank [0:15];
reg [15:0] mem[0:255];
 

always @(posedge clk1)
begin
  a<= #2 regbank[r1];
  b<= #2 regbank[r2];
  rd_l12<= #2 rd;
  fun_l12<= #2 func;
  addr_l12<= #2 addr;
  
end
always @(posedge clk2)
begin
case(fun_l12)
 0: z_l12<= #2 a+b;
 1: z_l12<=#2  a-b;
 2: z_l12<=#2  a*b;
 3: z_l12<=#2  a;
 4: z_l12<=#2  b;
 5: z_l12<=#2  a&b;
 6: z_l12<=#2  a|b;
 7: z_l12<=#2  a^b;
 8: z_l12<= #2 -a;
 9: z_l12<=#2  -b;
 10: z_l12<=#2  a>>1;
 11: z_l12<=#2  b>>1;
 default :z_l12<= #2 0;
  
endcase  
  rd_l21 <= #2 rd_l12;
  addr_l21 <=#2 addr_l12;

end

always @(posedge clk1)
begin

 
 z_l31<=#2 z_l12;
 regbank[rd_l21] <=#2 z_l12;
 addr_l31<= #2 addr_l21;
end


always @(posedge clk1)
begin

mem[addr_l31]<=#2z_l31;

end
 
assign f = z_l31;
endmodule

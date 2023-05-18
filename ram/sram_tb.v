module sram_tb;
reg [9:0] addr;
wire [7:0]d_out;
reg [7:0]d_in;
reg wr,cs;
integer k,myseed,p=0;

s_ram ramm(d_out,d_in,addr,wr,cs);

initial
begin
 for(k=0;k<=50;k=k+1)
   begin
     d_in=(k+k);wr=1;cs=1;
      #2 addr=k;wr=1;cs=0;
$display("Address %5d, data %4d",addr,d_in);
   end
  repeat(20)
   begin
     #2 addr= p;
     wr=0;cs=1;
     $display("Address %5d, data %4d",addr,d_out);
     p=p+1;
// wr=0;cs=1;
   end
end

initial myseed=35;
endmodule

module s_ram(d_out,d_in,addr,wr,cs);
parameter addr_size=10,word_size=8,mem_size=50 ;
input [addr_size-1:0]addr;
input [word_size-1:0]d_in;
input wr,cs;
output reg [word_size-1:0]d_out;
reg [word_size-1:0]mem[mem_size-1:0];
integer b=0;
//assign d_out=mem[addr];

always begin @(wr or cs)
if(wr)  
 mem[addr]=d_in;
 else 
  d_out<=mem[addr];
   
end
endmodule


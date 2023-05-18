module sram(d_out,d_in,addr,wr,cs);
parameter addr_size=10,wordsize=8,mem_size=1024;
input [addr_size-1:0]addr;
input [word-size-1:0]d_in;
input wr,cs;
output [word-size-1:0]d_out;
reg [word-size-1:0]mem[mem_size-1:0];

assign d_out=mem[addr];

always @(wr or cs)
  if(rw) mem[addr]=data_in;
endmodule


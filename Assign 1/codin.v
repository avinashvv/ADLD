module codin_tb;
reg clk;
reg car_at_fr;
reg car_at_bk;
reg [5:0]password,car_no;
wire err;
wire car_parkd;
integer j;

codin codd(clk,car_at_fr,password,car_no,car_at_bk,car_parkd,err);

initial 
begin
car_at_fr=0;
car_at_bk=0;
password=0;
car_no=0;

end

initial 
begin
clk=0;
repeat (100)
begin 
#1 clk=1; #1 clk=0;
end
end


initial begin
for(j=0;j<20;j=j+1)
begin
codd.pass_admin[j]=j;
codd.pass_car[j]=j;
end
end


initial
begin
#10
car_at_fr=1;
car_at_bk=0;
#5
password=6'b000001;
car_no=6'b000001;
#5
if(err==1'b1)
begin
car_at_bk=0;
car_at_fr=1;
$display("wrong credentials");
end
else
begin
$display("password granted");
car_at_bk=1;
car_at_fr=0;
end
#10
car_at_fr=0;
car_at_bk=0;
#10
car_at_fr=1;
car_at_bk=0;
#5
password=6'b000010;
car_no=  6'b000010;
#5
if(err==1'b1)
begin
car_at_bk=0;
car_at_fr=1;
$display("wrong credentials");
end
else
begin
$display("password granted");
car_at_bk=1;
car_at_fr=0;
end
#10
car_at_fr=0;
car_at_bk=0;

end


initial begin
if(car_parkd==1'b1)
$display("car parked !");
end

endmodule






module codin( clk,car_at_fr,password,car_no,car_at_bk,car_parkd,err );
input car_at_fr,car_at_bk;
input clk;
input [5:0]password,car_no;
output reg car_parkd,err;
integer i;

reg [5:0] Mem_pkd [0:20];

reg [5:0] pass_admin [0:20];
reg [5:0] pass_car [0:20];
reg [5:0] count=6'b000000;

parameter [1:0] fr_sen=2'b00,bk_sen=2'b01,parkd=2'b10;

reg if_fr=1'b0,if_bk=1'b0,if_pkd=1'b0;
reg [1:0] state;
reg yrs=0;

always @(posedge clk)
begin
if(car_at_fr==1'b1)
begin
state<=fr_sen;
if_fr<=1;
end
end
always @(posedge clk)
begin
if(car_at_bk==1'b1)
begin
if_bk<=1;
state<=bk_sen;
end
end

always @(posedge clk)
begin
      
end

always @(posedge clk)
begin
case(state)
fr_sen:begin
      if(if_fr == 1'b1)
      begin
       if((car_no==6'b000001 && password==6'b0000001)||(car_no==6'b000010 && password==6'b0000010))
       begin
       state<=bk_sen;
       if_fr<=0;
       if_bk<=1;
       err<=0;
        if_pkd<=0;
       car_parkd<=0;
       end
       else
       begin
       state<=fr_sen;
       if_fr<=1;
       if_bk<=0;
       err<=1;
        if_pkd<=0;
      car_parkd<=0;
       end
       
      end
       end
bk_sen:  begin
        if(if_bk==1'b1 && if_pkd==1'b0)
        begin
        state<=parkd;
        if_bk<=0;
        if_pkd<=1;
        car_parkd<=0;
        end
        else
        begin
        state<=bk_sen;
        if_bk<=1;
        if_pkd<=0;
        car_parkd<=0;
        end 
         end 
parkd:begin
         if(if_pkd==1'b1)
         begin
         Mem_pkd[count]<=car_no;
         count=count+1;
         if_pkd<=0;
         car_parkd<=1;
         err<= #2 1;
         end
      end
default:state<=fr_sen;

endcase
end



endmodule

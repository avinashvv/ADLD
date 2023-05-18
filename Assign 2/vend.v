module vend_tb;
reg [1:0] product;
reg [4:0] money;
wire is_vent;
wire [4:0]remain_amt;

vend machin(product,money,remain_amt,is_vent);

initial begin
 
product=0;
money=0;
#5;

product=0;
money=5;
#40;


product=1;
money=5;
#20 
money=10;
#40;


product=0;
money=0;

#100;
$finish;
end
endmodule





module vend(product,money,remain_amt,is_vent);
input [1:0] product;
input [4:0] money;
output reg is_vent;
output reg [4:0]remain_amt;

reg [3:0]count=0;
parameter [1:0] start=2'b00, prod_type=2'b01, amount=2'b10, ventit=2'b11;
parameter [4:0] p_A=5'b00101, p_B=5'b01010,p_C=5'b01111,p_D=5'b10100;
reg [1:0] state;
reg if_product,if_pro_matched,if_amt;
reg [4:0]st_amt=0;


always @(*)
if(money==0)
state<=start;

always @(*)
begin
case(state)
start:   begin
           if(product>=0 && money>0)
            begin
            if_product<= #10 1;
            count<=#10 0;
             state<= prod_type;
             end 
            else
              begin
            state<=start;
            if_product<=0;
              end 
         end
prod_type:begin
         if(if_product==1)
         begin
          if(product==2'b00||product==2'b01||product==2'b10||product==2'b11)
           begin
           if_pro_matched<=#10 1;
           state<=amount;
           end          
           else
          begin
           state<=start;
           if_pro_matched<=#10 0;
          end
         end
        end
amount:   begin
          if(if_pro_matched==1)
          begin
           case(product)
          2'b00:begin 
                remain_amt<=st_amt-5'b00101;
                state<=ventit;
                st_amt<=0;
                if_amt<=#10 1;
                end
          2'b01:begin
                 if(st_amt>=5'b01010)
                 begin
                 remain_amt<=st_amt-5'b01010;
                 state<=ventit;
                 if_amt<=#10 1;
                 end
                 else
                 begin
                 state<=amount;
                 if_amt<=#10 0; 
                 end
                end      
          2'b10:begin
                   if(st_amt>=5'b01111)
                   begin
                   remain_amt<=st_amt-5'b01111;
                   state<=ventit;
                   if_amt<=#10 1;
                   end
                   else
                   begin
                   state<=amount;
                   if_amt<=#10 0; 
                   end
                end
          2'b11:begin
                   if(st_amt>=5'b10100)
                   begin
                   remain_amt<=st_amt-5'b10100;
                   state<=ventit;
                   if_amt<=#10 1;
                   end
                   else
                   begin
                   state<=amount;
                   if_amt<=#10 0; 
                   end
                end          
          endcase
          end
          end

ventit: begin
           if(if_amt==1)
           begin
           is_vent<=1;
           if_amt<=0;
           if_pro_matched<=0;
           is_vent<=#10 0;
           state<=start;
           end
        end
default:state<=start;
endcase
end

      always@(money)
        begin 
           st_amt <= money+st_amt;
        end

endmodule

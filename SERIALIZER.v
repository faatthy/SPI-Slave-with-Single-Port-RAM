module SERIALIZER(
    input rst,clk,
    input [7:0] data,
    output reg ser_out,
    input data_valid,ss_n
);

reg [7:0] registers;
reg [3:0] counter=4'b0000; //counter i will use it to in every clock i will out one bit
always @(posedge clk,negedge rst)
begin
  if(!rst)
  begin
    counter<=2'b00;
    registers<=8'b00;
    ser_out<=1'b0;
  end
  else if(data_valid)
  begin
    registers<=data;
    ser_out<=1'b0;
    counter<=4'b0000;
  end
  else if(!ss_n)
  begin
    if (counter!=4'd8) begin
      {registers,ser_out}<={1'b0,registers};
    counter<=counter+1;
    end
    else begin
      counter<=4'd0;
    end
  end
else
counter<=4'b0000;

end
endmodule


module deserializer(
    input serial_data,
    input clk,rst,
    input deser_en,
    output reg[9:0] parallel_data,
    output reg data_valid
);
reg [3:0] counter ;
always @(posedge clk,negedge rst) begin
    if (!rst) begin
        parallel_data<=10'b0;
        counter<=4'b0;
        data_valid<=1'b0;
    end
    else if (deser_en) begin
        if(counter!=4'd10)begin
        parallel_data<={serial_data,parallel_data[9:1]};
        counter<=counter+1'b1;
        data_valid<=1'b0;
        end
        else begin
          data_valid<=1'b1;
          counter<=4'b0;
        end
    end
    else
    begin
      data_valid<=1'b0;
    end
end
endmodule

module SPI_Slave(
    input MOSI,
    input clk,rst,ss_n,
    input tx_valid,
    output wire MISO,
    input [7:0]tx_data,
    output wire [9:0]rx_data,
    output wire rx_valid
);
wire deserializer_en;
localparam IDLE_State     =2'b00;
localparam CHECK_CMD_State=2'b01;
localparam READ_State     =2'b10;
localparam WRITE_State    =3'b11;

reg[1:0] state_next;
reg[1:0] state_reg;
always @(posedge clk,negedge rst) begin
    if (!rst) begin
        state_reg<=3'b00;
    end
    else begin
      state_reg<=state_next;
    end
end
always @(*) begin
    case (state_reg)
        IDLE_State:begin
          if (ss_n) begin
            state_next<=IDLE_State;
          end
          else begin
            state_next<=CHECK_CMD_State;
          end
        end 
        CHECK_CMD_State:begin
          if (ss_n) begin
            state_next<=IDLE_State;
          end
          else begin
            if (MOSI) begin
                state_next<=READ_State;
            end
            else begin
              state_next<=WRITE_State;
            end
          end
        end
        READ_State:begin
          if (ss_n) begin
            state_next<=IDLE_State;
          end
          else if(ss_n)begin
            state_next<=READ_State;
          end
        end
        WRITE_State:begin
          if (ss_n) begin
            state_next<=IDLE_State;
          end
          else if(ss_n)begin
            state_next<=WRITE_State;
          end
        end
        default: state_next<=IDLE_State;
    endcase
end


assign deserializer_en=(state_reg!=IDLE_State&&state_reg!=CHECK_CMD_State)?1'b1:1'b0;


//**instantiate SERIALIZER and deserializer**//

deserializer  Deserializer_SPI(
    .serial_data(MOSI),
    .clk(clk),
    .rst(rst),
    .deser_en(deserializer_en),
    .parallel_data(rx_data),
    .data_valid(rx_valid)
);


SERIALIZER SERIALIZER_SPI(
   .rst(rst),
   .clk(clk),
   .data(tx_data),
   .ser_out(MISO),
   .data_valid(tx_valid),
   .ss_n(ss_n)
);


endmodule
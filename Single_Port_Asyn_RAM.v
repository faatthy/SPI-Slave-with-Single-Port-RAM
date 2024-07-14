module Single_Port_Asyn_RAM #(parameter MEM_DEPTH =256,parameter ADDR_SIZE=8)( 
    input [9:0]din,
    input clk,rst,rx_valid,
    output reg [7:0] dout,
    output reg tx_valid
);
reg [ADDR_SIZE-1:0] MEMORY [0:MEM_DEPTH-1];
reg [ADDR_SIZE-1:0] write_address,read_address;
always @(posedge clk,negedge rst) begin
    if (!rst) begin
        dout<=8'b0;
        tx_valid<=1'b0;
        write_address<='b0;
        read_address<='b0;
    end
    else if(rx_valid)
    begin
      case (din[9:8])
        2'b00:begin
          write_address<=din[7:0];
        end 
        2'b01:begin
          MEMORY[write_address]<=din[7:0];
        end
        2'b10:begin
          read_address<=din[7:0];
        end
        2'b11:begin
          dout<=MEMORY[read_address];
          tx_valid<=1'b1;
        end
        default: begin
          dout<=8'b0;
          tx_valid<=1'b0;
          write_address<='b0;
          read_address<='b0;
        end
      endcase
    end
end

endmodule
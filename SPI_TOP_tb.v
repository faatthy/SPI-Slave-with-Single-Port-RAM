module SPI_TOP_tb();

    // Signal declaration
    reg clk, rst_n, MOSI, SS_n;
    wire MISO_DUT;
    
    // DUT instantiation
    SPI_TOP DUT(clk, rst_n, SS_n, MOSI, MISO_DUT);
    
    // Clock generation block
    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end
    
    // Initial block
    integer i;
    initial begin
        INITIALIZE_TASK();
        RST_TASK();
        OPERATION(3'b000, 8'h55); // rx_data = address of 55H (write address)
        @(negedge clk);
        OPERATION(3'b001, 8'hAA); // rx_data = data of AAH to be stored in address of 55H
        @(negedge clk);
        OPERATION(3'b110, 8'h55); // rx_data = address of 55H (read address)
        @(negedge clk);
        OPERATION(3'b111, 8'h55); // rx_data = dummy data, Tx_data = AAH
        @(negedge clk);
        CHECK_MISO_OUTPUT(8'hAA);
        #10;
        $stop;
    end
    
    // Tasks
    task RST_TASK;
        begin
            rst_n = 1'b0;
            @(negedge clk);
            @(negedge clk);
            rst_n = 1'b1;
        end
    endtask

    task INITIALIZE_TASK;
        begin
            MOSI = 1'b1;
            SS_n = 1'b1;
        end
    endtask

    task OPERATION(input [2:0] OperationBits, input [7:0] DATA);
        begin
            // Start of communication
            SS_n = 0;
            @(negedge clk);
            MOSI = OperationBits[2]; // first bit on MOSI to determine the operation type (write or read)
            @(negedge clk);
            MOSI = OperationBits[1]; // din[9]
            @(negedge clk);
            MOSI = OperationBits[0]; // din[8]
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                MOSI = DATA[7 - i];  // send MSB first
            end
            // End of communication
            @(negedge clk);
            SS_n = 1'b1; 
        end
    endtask

    task CHECK_MISO_OUTPUT(input [7:0] tx_data);
        begin
            @(negedge clk);
            @(negedge clk);
            // Start of communication
            SS_n = 0;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                if (MISO_DUT == tx_data[7 - i]) begin
                    $display("MISO transmit successfully");
                end
            end
            // End of communication
            SS_n = 1'b1;
        end
    endtask

endmodule

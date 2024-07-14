# SPI Slave with Single Port RAM
This project implements a SPI (Serial Peripheral Interface) slave module with a single port RAM block. The SPI slave module receives data from a master device and communicates with the single port RAM to store and retrieve data.
![SYSTEM LEVEL](https://drive.google.com/uc?export=view&id=1EHmCvaM_t_xybyCshayAZgYSlHrNebHS)

### Project Overview
The project consists of the following:-
1. Codes folder:
    which contain the following 
	+ ram.dat: which represents the memory for the testbench
	+ run.do: do file to run simulation in QuestaSim or ModelSim
	+ RTL folder:
		+ SPI.v: design of SPI block
		+ RAM.v: design of RAM block
		+ instantiation.v: top module
		+ run.txt: txt file to run design on Vivado and extract elaboration_shcematic.pdf, synthesized_shcematic.pdf, utilization report and report timing
			   in addition to run  elaboration, synthesis, implementation and generates bitstream file
	+ Testbench folder:
		+ SPI.v: Verilog file represent SPI Slave block
    		+ RAM.v: Verilog file represent Single Port Async RAM


## SPI Slave Module
The SPI slave module is responsible for receiving data from the master device and interacting with the RAM module. It has the following ports:

|    Name   | Type | Size | Description |
| :---: | :---: | :---: | :---  |
| clk       |  Input | 1 bit  | Clock signal |
| rst_n     |  Input | 1 bit  | Active low reset signal |
| SS_n      |  Input | 1 bit  | Slave Select signal |
| MOSI      |  Input | 1 bit  | Master-Out-Slave-In data signal |
| tx_data   |  Input | 10 bit | Transfer data output signal, Takes MOSI for 10 clock cycles and stores it in tx_data to send it to the RAM |
| tx_valid  |  Input | 1 bit  | Indicates when tx_data is valid |
| MISO      | Output | 1 bit  | Master-In-Slave-Out data signal |
| rx_data   | Output | 10 bit | Received data from the memory |
| rx_valid  | Output | 1 bit  | Indicates when rx_data is valid |

## Single Port Async RAM Module
The single port asynchronous RAM module implements a memory block with a single data port.

* It has the following parameters:
  - MEM_DEPTH (default: 256): Depth of the memory.
  - ADDR_SIZE (default: 8): Size of the memory address.

* Ports:
  
|    Name   | Type | Size | Description |
| :---: | :---: | :---: | :---  |
| clk       |  Input   | 1 bit   | Clock signal |
| rst_n     |  Input   | 1 bit   | Active low reset signal |
| din       |  Input   | 10 bit  | Data input |
| rx_valid  |  Input   | 1 bit   | If HIGH, accepts din[7:0] to save the write/read address internally or writes a memory word depending on the most significant 2 bits din[9:8] |
| dout      |  Output  | 8 bit   | Data output |
| tx_valid  |  Output  | 1 bit   | Whenever the command is a memory read, tx_valid should be HIGH |

* The most significant bits of din (din[9:8]) determine the operation to be performed:

|    Port   | din[9:8] | Command | Description |
| :---: | :---: | :---: | :---  |
| din   | 00 | Write | Holds din[7:0] internally as a write address |
| din   | 01 | Write | Writes din[7:0] to the memory with the write address held previously |
| din   | 10 | Read  | Holds din[7:0] internally as a read address |
| din   | 11 | Read  | Reads the memory with the read address held previously. tx_valid should be HIGH, and dout holds the word read from the memory. din[7:0] is ignored |

### Wire connections:
* rx_data in the SPI slave module is connected to the din port in the RAM module.
* rx_valid in the SPI slave module is connected to rx_valid in the RAM module.
* dout in the RAM module is connected to tx_data in the SPI slave module.
* tx_valid in the RAM module is connected to tx_valid in the SPI slave module.

### FSM "Finite State Machine"
![FSM](https://drive.google.com/uc?export=view&id=1hf9omcZ275hoKuVw7Ol5CuG-cZuh6jIJ)

## Schematic VIVADO
![Screenshot 2024-07-14 082734](https://github.com/user-attachments/assets/18213a73-801a-41c6-aa22-9779e00402d3)

## Waveform
![Screenshot 2024-07-14 084220](https://github.com/user-attachments/assets/1b4b2b64-3c91-47fa-bb89-b587175c269a)

# Course Project 1 [Microprocessor Theory Course]

## Problem Statement: 
<br>
Design a multi-­‐cycle processor, IITB-­‐RISC, whose instruction set architecture is provided. Use VHDL as HDL to implement. The IITB_RISC is an 8-register, 16 bit computer system. The architecture must be optimized for performance. It should use point-to-point communication infrastructure. 

<br>

We did this project as a team of 4. 
Team Members: 
- Pranav Sankhe       150070009
- Sachin Goyal        150020069  
- Srivatsan Shridhar  150070005 
- Tanya Chaudhary     150070033  

Here are the details regarding the exact implementation:[Click Here](https://github.com/sabSAThai/Micro-Lab/blob/master/project1/problem_statement/Project-1-Multicycle-RISC-IITB.pdf) 


## Details Regarding included code file 

- `datapath.vhdl` implements our datapath infrastructure and `control_path.vhdl` implements the control flow.

- `TRACEFILE.txt` and `datapath_trace.txt` are the tracefiles we used to check our control path and datapath VHDL codes. 

- `trace_invert.py` is a python script to invert the inputs and outputs of the controlpath which serves as a tracefile for the datapath debugging. 

- `OUTPUTS.txt` is used to store the outputs after testing the vhdl files on a tracefile. 

- `testbench_control.vhd` and `testbench_path.vhd` are testbenches for control and data path vhdl files respectively. 

- `datapath_fpga.vhdl` is the file we uploaded on FPGA. 

- `Control Store - Sheet1.pdf` has the control store of our implementation. 


### Tracefile Description 

**Data path:**

`input`:(28)
- clock(1)
- reset(1)
- mux4ALU(2)
- mux8ALU (3)
- Mux2 (5)
- mux4RF(4)
- mux8RFa3(3)
- en(4)
- var(3)
- cz_en(2)
		
`output`:(10)
- carry(1)
- zero(1)
- valid(1)
- op_code_bits(4)
- cz_bits(2)
- eq_T1_T2(1)
    
**Control path:**
`input`:(12)
- clock(1)
- reset(1)
- carry(1)
- zero(1)
- valid(1)
- op_code_bits(4)
- cz_bits(2)
- eq_T1_T2(1)
		
`output`:(26)
- mux4ALU (2)
- mux8ALU (3)
- Mux2 (5)
- mux4RF (4)
- mux8RFa3(3)
- en(4)
- var(3)
- cz_en(2)


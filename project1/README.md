# Course Project 1 [Microprocessor Theory Course]

## Problem Statement: 
<br>
Design a multi-­‐cycle processor, IITB-­‐RISC, whose instruction set architecture is provided. Use VHDL as HDL to implement. The IITB_RISC is an 8-register, 16 bit computer system. The architecture must be optimized for performance. It should use point-to-point communication infrastructure. 

<br>

We did this project as a team of 4. 
Team Members: 
- Pranav Sankhe
- Sachin Goyal 
- Srivatsan Shridhar
- Tanya Chaudhary 

Here are the details regarding the exact implementation:[Click Here](https://github.com/sabSAThai/Micro-Lab/blob/master/project1/problem_statement/Project-1-Multicycle-RISC-IITB.pdf) 


## Details Regarding included code file 

- `control path.vhdl` : Implements the control flow of machine instructions. 

- `datapath.vhdl` : Implements the dataflow of the processor. 

- `testbench_control.vhdl` : A customized testbench to test(debug) the designed control path. 


### Tracefile Description 

**Data path:**

`input`:    
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
		
`output`:		
- carry(1)
- zero(1)
- valid(1)
- op_code_bits(4)
- cz_bits(2)
- eq_T1_T2(1)
    
**Control path:**
`input`:
- clock(1)
- reset(1)
- carry(1)
- zero(1)
- valid(1)
- op_code_bits(4)
- cz_bits(2)
- eq_T1_T2(1)
		
**output:**
- mux4ALU (2)
- mux8ALU (3)
- Mux2 (5)
- mux4RF (4)
- mux8RFa3(3)
- en(4)
- var(3)
- cz_en(2)


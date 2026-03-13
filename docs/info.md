<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements an integer square root module which computes the floor of the square root of an unsigned input value.

$\text{root}=\lfloor{\sqrt{\text{radicand}}}\rfloor{}$

On `start`, the input radicand is loaded and the computation begins. The start is asserted by a rising edge of the active low reset signal `rst_n`. Each clock cycle processes two bits of the input, updating an internal remainder and builds the result one bit at a time. After 5 cycles, the result is available on the `uo_out` output.

To time the read of the values simply wait a sufficient amount of time. The module will enter an idle state that retains uo_out after the computation finishes so the timing of the read isn't critical. The reset signal is active high and returns the module to the idle state. 


## How to test

Testing is done using cocotb.

Run 
```
cd test
make -B
```
To view test results in terminal.


## External hardware

No external hardware is needed.

## Sufficiency of testbench

The testbench is sufficient because it tests necessary edge cases and also randomized numbers within the valid input range of the verilog module. Since the design is synchronous, there is no need to test edge cases such asynchronous input as that it not how it is intended to be used. 

## Use of generative AI

Ai was used to generate the verilog and the testbench. The docs were written myself. 
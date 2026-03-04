<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements an integer square root module which computes the floor of the square root of an unsigned input value.

$\text{root}=\lfloor{\sqrt{\text{radicand}}}\rfloor{}$

On `start`, the input radicand is loaded and the computation begins. Each clock cycle processes two bits of the input, updating an internal remainder and builds the result one bit at a time. After WIDTH/2 cycles, the result is available on the `root` output.

The `busy` signal is asserted while computation is in progress. The `done` signal is asserted for one clock cycle when the result is ready. The reset signal is active high and returns the module to the idle state. During this reset sate both `done` and `busy` will be low.


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
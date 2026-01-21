# Systolic-Array-Matrix-Multiplier-for-Neural-Networks
Systolic-Array Matrix Multiplier for Neural Networks in SystemVerilog targetting FPGA hardware.

C = A x B

Mk1: I made a 2x2 matrix multiplier where you stream in the whole B matrix and stream in rows of A

for mk2 i will optimize the skew buffer to allow for cycle by cycle loads of columns of A in an efficient way.
i will also increase the matrix to 8x8 size. i will also make it such that B is loaded column by column
another thing i will be doing is a specialized 8x8 output buffer for matrix C

I HAVE FINISHED THE MK2

i am researching tiling

Mk3 Roadmap:

1. (DONE) Improve throughput of 8x8 pipeline by loading columns as the systolic array computes

2. (DONE) Increase size of processing element grid to 16x16

3. (DONE) Create enable tree

4. (DONE) Create Fifo buffers for queuing tiles for the architecture

5. Create accumulation registers

6. Create unified buffer

7. Create the ram interface for the unified buffer

8. Create new controller (that triple nested for loop for tiling) that controls current controller

9. Implement bias, activation, and pooling
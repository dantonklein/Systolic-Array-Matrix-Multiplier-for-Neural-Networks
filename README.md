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

2. Increase size of processing element grid to 16x16, create enable tree

3. Create Fifo buffers for queuing tiles for the architecture

4. Create accumulation registers

5. Create unified buffer

6. Create the ram interface for the unified buffer

7. Create new controller (that triple nested for loop)

8. Implement bias, activation, and pooling
# Systolic-Array-Matrix-Multiplier-for-Neural-Networks
Systolic-Array Matrix Multiplier for Neural Networks in SystemVerilog targetting FPGA hardware.

C = A x B

Mk1: I made a 2x2 matrix multiplier where you stream in the whole B matrix and stream in rows of A

for mk2 i will optimize the skew buffer to allow for cycle by cycle loads of columns of A in an efficient way.
i will also increase the matrix to 8x8 size. i will also make it such that B is loaded column by column

for mk3 i will introduce tiling to allow for any sized matrix in addition to an axi stream interface
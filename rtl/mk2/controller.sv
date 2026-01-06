module controller (
    input logic clk,
    input logic rst,

    input logic start,
    output logic done,
    output logic ready,

    input logic signed [7:0] a_data[8],
    input logic signed [7:0] b_data[8],

    output logic signed [31:0] c_data[8]
);


endmodule
//this is the top level entity for the mk2 of the systolic array mat mult.
//i am making the assumption that the hypothetical A and B buffers(that will be made in mk3) are available at the same time


module systolic_array_mat_mult_8x8 (
    input logic clk,
    input logic rst,

    input logic start,
    output logic done,
    output logic ready,

    input logic a_valid,
    output logic a_ready,
    input var logic signed [7:0] a_in[8],

    input logic b_valid,
    output logic b_ready,
    input var logic signed [7:0] b_in[8],

    output logic c_valid,
    input logic c_ready,
    output var logic signed [31:0] c_out[8]
);

logic enable, input_write, output_write, output_read;

logic[2:0] row_ptr;

controller CONTROLLER (
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done),
    .ready(ready),
    .a_valid(a_valid),
    .a_ready(a_ready),
    .b_valid(b_valid),
    .b_ready(b_ready),
    .enable(enable),
    .input_write(input_write),
    .output_write(output_write),
    .row_ptr(row_ptr),
    .c_valid(c_valid)
);

assign output_read = c_valid & c_ready;

eight_x_eight #(
    .DATA_WIDTH(8),
    .ACC_WIDTH(32)
) EIGHT_X_EIGHT (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .input_write(input_write),
    .output_write(output_write),
    .output_read(output_read),
    .row_ptr(row_ptr),
    .a_in(a_in),
    .b_in(b_in),
    .c_out(c_out)
);

endmodule
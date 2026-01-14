//this is the top level entity for the mk2 of the systolic array mat mult.
//i am making the assumption that the hypothetical A and B buffers(that will be made in mk3) are available at the same time


module systolic_array_mat_mult_16x16mk3 (
    input logic clk,
    input logic rst,

    input logic start,
    output logic done,
    output logic ready,

    //input logic a_valid,
    //output logic a_ready,
    input logic a_wr_en,
    input var logic signed [127:0] a_fifo_in,
    output logic a_full,

    //input logic b_valid,
    //output logic b_ready,
    input logic b_wr_en,
    input var logic signed [127:0] b_fifo_in,
    output logic b_full,

    output logic c_valid,
    input logic c_ready,
    output var logic signed [31:0] c_out[16]
);
logic signed[7:0] a_in[16], b_in[16];
logic a_valid, a_ready, b_valid, b_ready;
logic[6:0] a_count, b_count;

logic enable, input_write, output_write, output_read, read_valid;

logic[3:0] row_ptr;

controller CONTROLLER (
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done),
    .ready(ready),
    .a_valid(a_valid),
    .a_ready(a_ready),
    .a_count(a_count),
    .b_valid(b_valid),
    .b_ready(b_ready),
    .b_count(b_count),
    .enable(enable),
    .input_write(input_write),
    .output_write(output_write),
    .row_ptr(row_ptr),
    .read_valid(read_valid),
    .c_valid(c_valid)
);

assign output_read = c_valid & c_ready;

systolic_array #(
    .DATA_WIDTH(8),
    .ACC_WIDTH(32)
) SYSTOLIC_ARRAY (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .input_write(input_write),
    .output_write(output_write),
    .output_read(output_read),
    .read_valid(read_valid),
    .row_ptr(row_ptr),
    .a_in(a_in),
    .b_in(b_in),
    .c_out(c_out)
);

//fifo signals
logic signed [127:0] a_fifo_out, b_fifo_out;
logic rd_en;
logic a_empty, b_empty; 

generate
    for(genvar i = 0; i < 16; i++) begin
        assign a_in[i] = a_fifo_out[8*(i+1)-1:8*i];
        assign b_in[i] = b_fifo_out[8*(i+1)-1:8*i];
    end
endgenerate

assign rd_en = a_valid && a_ready && b_valid && b_ready;
assign a_valid = !a_empty;
assign b_valid = !b_empty;

fifo #(
    .WIDTH(128),
    .DEPTH(64)
) a_fifo (
    .clk(clk),
    .rst(rst),
    .full(a_full),
    .wr_en(a_wr_en),
    .wr_data(a_fifo_in),
    .empty(a_empty),
    .rd_en(rd_en),
    .rd_data(a_fifo_out),
    .count(a_count)
);

fifo #(
    .WIDTH(128),
    .DEPTH(64)
) b_fifo (
    .clk(clk),
    .rst(rst),
    .full(b_full),
    .wr_en(b_wr_en),
    .wr_data(b_fifo_in),
    .empty(b_empty),
    .rd_en(rd_en),
    .rd_data(b_fifo_out),
    .count(b_count)
);

endmodule
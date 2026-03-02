//K index bleh bleh blah

module accumulation_register #(
    parameter int ARRAY_SIZE = 16,
    parameter int DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,

    input logic data_valid,
    input logic[3:0] row_index,

    input logic clear,
    input logic read,

    output logic valid,
    output logic done,
    output logic ready,

    input var logic signed [DATA_WIDTH-1:0] data_in [ARRAY_SIZE],
    output var logic signed [DATA_WIDTH-1:0] data_out [ARRAY_SIZE]

);

endmodule
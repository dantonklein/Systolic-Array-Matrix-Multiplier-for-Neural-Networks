//K index bleh bleh blah

module accumulation_register #(
    parameter int ARRAY_SIZE = 16,
    parameter int DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,

    input logic data_valid,
    input logic k_tile_last,

    input logic clear,
    input logic read,

    output logic valid,
    output logic done,
    output logic ready,

    input var logic signed [DATA_WIDTH-1:0] data_in [ARRAY_SIZE],
    output var logic signed [DATA_WIDTH-1:0] data_out [ARRAY_SIZE]

);
    logic[DATA_WIDTH-1:0] accum_reg[ARRAY_SIZE][ARRAY_SIZE];
    logic[$clog2(ARRAY_SIZE)-1:0] row_counter;

    typedef enum logic [1:0] {
        IDLE,
        ACCUMULATE,
        READING
    } state_t;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin

        end else begin

        end
    end
endmodule
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
    //adding and writing in one cycle is a timing violation waiting to happen
    logic[DATA_WIDTH-1:0] sums[ARRAY_SIZE];
    logic[$clog2(ARRAY_SIZE)-1:0] row_counter;

    typedef enum logic [1:0] {
        IDLE,
        ACCUMULATE,
        READING
    } state_t;

    state_t state_r;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state_r <= IDLE;
            for(int i = 0; i < ARRAY_SIZE; i++) begin
                sums[i] <= 0;
            end
            //set at max row count
            row_counter <= 0 - 1;
            done <= 0;
        end else begin
            done <= 0;
            case(state_r)
                IDLE: begin
                    //reset counter
                    row_counter <= 0 - 1;
                end
                ACCUMULATE: begin

                end
                READING: begin

                end
            endcase
        end
    end
endmodule
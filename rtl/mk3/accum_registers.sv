//K index bleh bleh blah

module accumulation_register #(
    parameter int ARRAY_SIZE = 16,
    parameter int DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,

    input logic data_valid,
    input logic k_tile_last,

    input logic k_tile_first,

    output logic valid,
    output logic done,
    output logic ready,

    input var logic signed [DATA_WIDTH-1:0] data_in [ARRAY_SIZE],
    output var logic signed [DATA_WIDTH-1:0] data_out [ARRAY_SIZE]

);
    initial begin
        if (ARRAY_SIZE < 2) $fatal(1, "ERROR: Array Size Too Small.");
        if (DATA_WIDTH < 1) $fatal(1, "ERROR: Data Width Too Small.");
    end
    logic[DATA_WIDTH-1:0] accum_reg[ARRAY_SIZE][ARRAY_SIZE];
    //adding and writing in one cycle is a timing violation waiting to happen
    logic[DATA_WIDTH-1:0] sums[ARRAY_SIZE];
    logic[$clog2(ARRAY_SIZE)-1:0] row_counter;

    //calculate sums across the rows
    always_comb begin
        for(int i = 0; i < ARRAY_SIZE; i++) begin
            if(k_tile_first) sums[i] = data_in[i]; //for first k tile
            else sums[i] = accum_reg[row_counter][i] + data_in[i]; //for other tiles
        end
    end

    //output the register file
    always_comb begin
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            data_out[i] = accum_reg[row_counter][i];
        end
    end

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
            row_counter <= 0;
            done <= 0;
            ready <= 0;
            valid <= 0;
        end else begin
            done <= 0;
            ready <= 0;
            valid <= 0;
            case(state_r)
                IDLE: begin
                    //reset counter
                    //row_counter <= 0;
                    if(data_valid) begin
                        state_r <= ACCUMULATE;
                        for(int i = 0; i < ARRAY_SIZE; i++) begin
                            accum_reg[row_counter][i] <= sums[i];
                        end
                        row_counter <= row_counter + 1;
                    end
                    else ready <= 1;
                end
                ACCUMULATE: begin
                    //write the sum into a given row
                    for(int i = 0; i < ARRAY_SIZE; i++) begin
                        accum_reg[row_counter][i] <= sums[i];
                    end

                    if (row_counter == ARRAY_SIZE - 1) begin
                        row_counter <= '0;
                        state_r <= k_tile_last ? READING : IDLE;
                        valid <= 1;
                    end else begin
                        row_counter <= row_counter + 1;
                    end
                end
                READING: begin
                    valid <= 1;
                    if(read) begin //axi stream interface
                        if (row_counter == ARRAY_SIZE - 1) begin
                            row_counter <= '0;
                            state_r <= IDLE;
                            valid <= 0;
                        end else begin
                            row_counter <= row_counter + 1;
                        end
                    end
                end
            endcase
        end
    end
endmodule
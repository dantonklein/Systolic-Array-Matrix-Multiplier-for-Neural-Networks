module eight_x_eight #(
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic enable,
    input logic write,
    input logic[2:0] row_ptr,
    //weight matrix (B matrix)
    input var logic signed [DATA_WIDTH-1:0] b_in[8],
    //activation matrix (A matrix)
    input var logic signed [DATA_WIDTH-1:0] a_in[8],
    output var logic signed [ACC_WIDTH-1:0] c_out[8]
);
    //output of skew buffer
    logic signed [DATA_WIDTH-1:0] a_skewed [8];

    skew_buffer2 #(
        .ARRAY_SIZE(8),
        .DATA_WIDTH(DATA_WIDTH)
    ) skew_buff2 (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .write(write),
        .row_ptr(row_ptr),
        .data_in(a_in),
        .data_out(a_skewed)
    );

    //internal a connections
    logic signed [DATA_WIDTH-1:0] a_internals[8][8];

    logic signed [ACC_WIDTH-1:0] c_internals[9][8];

    
    generate
        for(genvar i = 0; i < 8; i++) begin
            //left side assignments
            assign a_internals[i][0] = a_skewed[i];

            //top assignments
            assign c_internals[0][i] = '0;

            //output assignments
            assign c_out[i] = c_internals[8][i];
        end
    endgenerate

    //b write logic
    logic b_write_column[8];
    always_comb begin
        b_write_column = '{default: 0};
        b_write_column[row_ptr] = write;
    end

    //instantiation of the array
    generate
        for(genvar row = 0; row < 8; row++) begin
            for(genvar column = 0; column < 8; column++) begin
                if(column == 7) begin
                    ws_pe_no_a_out #(
                        .DATA_WIDTH(DATA_WIDTH),
                        .ACC_WIDTH(ACC_WIDTH)
                    ) no_a_out (
                        .clk(clk),
                        .rst(rst),
                        .enable(enable),

                        //load b matrix
                        .b_load(b_write_column[column]),
                        .b_in(b_in[row]),

                        //horizontal dataflow
                        .a_in(a_internals[row][column]),

                        //vertical dataflow
                        .c_in(c_internals[row][column]),
                        .c_out(c_internals[row+1][column])
                    );
                end
                else begin
                    ws_pe #(
                        .DATA_WIDTH(DATA_WIDTH),
                        .ACC_WIDTH(ACC_WIDTH)
                    ) normal (
                        .clk(clk),
                        .rst(rst),
                        .enable(enable),

                        //load b matrix
                        .b_load(b_write_column[column]),
                        .b_in(b_in[row]),

                        //horizontal dataflow
                        .a_in(a_internals[row][column]),
                        .a_out(a_internals[row][column+1]),

                        //vertical dataflow
                        .c_in(c_internals[row][column]),
                        .c_out(c_internals[row+1][column])
                    );
                end
            end
        end
    endgenerate
endmodule
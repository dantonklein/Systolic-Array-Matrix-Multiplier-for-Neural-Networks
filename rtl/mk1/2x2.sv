module two_x_two #(
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic enable,

    //weight matrix (B matrix)
    input logic b_load,
    input var logic signed [DATA_WIDTH-1:0] b_in[2][2],

    input var logic signed [DATA_WIDTH-1:0] a_in[2],
    output var logic signed [ACC_WIDTH-1:0] c_out[2]
);
    //output of skew buffer
    logic signed [DATA_WIDTH-1:0] a_skewed [2];

    skew_buffer #(
        .ARRAY_SIZE(2),
        .DATA_WIDTH(DATA_WIDTH)
    ) skew_buff (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .data_in(a_in),
        .data_out(a_skewed)
    );
    //internal a connections
    logic signed [DATA_WIDTH-1:0] a_internals[2][2];

    logic signed [ACC_WIDTH-1:0] c_internals[3][2];

    //left side assignments
    assign a_internals[0][0] = a_skewed[0];
    assign a_internals[1][0] = a_skewed[1];

    //top assignments
    assign c_internals[0][0] = '0;
    assign c_internals[0][1] = '0;

    assign c_out[0] = c_internals[2][0];
    assign c_out[1] = c_internals[2][1];

    //instantiation of the array
    generate
        for(genvar row = 0; row < 2; row++) begin
            for(genvar column = 0; column < 2; column++) begin
                if(column == 1) begin
                    ws_pe_no_a_out #(
                        .DATA_WIDTH(DATA_WIDTH),
                        .ACC_WIDTH(ACC_WIDTH)
                    ) no_a_out (
                        .clk(clk),
                        .rst(rst),
                        .enable(enable),

                        //load b matrix
                        .b_load(b_load),
                        .b_in(b_in[row][column]),

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
                        .b_load(b_load),
                        .b_in(b_in[row][column]),

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
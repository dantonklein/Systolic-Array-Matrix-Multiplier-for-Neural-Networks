module eight_x_eight_tb;
    parameter int DATA_WIDTH = 8;
    parameter int ACC_WIDTH = 32;

    logic clk = 1'b0;
    logic rst;
    logic enable;
    logic write;
    logic[2:0] row_ptr;
    logic signed [DATA_WIDTH-1:0] b_in[8];

    logic signed [DATA_WIDTH-1:0] a_in[8];
    logic signed [ACC_WIDTH-1:0] c_out[8];

    eight_x_eight #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) dut (.*);

    initial begin: generate_clk
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
    

    //testing C = A * B
    //A = [1 2] B = [5 6] C = [19 22]
    //    [3 4]     [7 8]     [43 50]
    initial begin
        rst <= 1;
        enable <= 0;
        b_load <= 0;
        @(posedge clk);
        rst <= 0;
        @(posedge clk);

        //load b
        b_in[0][0] <= 5;
        b_in[0][1] <= 6;
        b_in[1][0] <= 7;
        b_in[1][1] <= 8;
        b_load <= 1;
        @(posedge clk);
        b_load <= 0;

        //load a
        a_in[0] <= 1;
        a_in[1] <= 2;
        enable <= 1;
        @(posedge clk);

        a_in[0] <= 3;
        a_in[1] <= 4;
        enable <= 1;
        @(posedge clk);

        a_in[0] <= 0;
        a_in[1] <= 0;
        enable <= 1;

        repeat(9) @(posedge clk);
        disable generate_clk;
    end
endmodule
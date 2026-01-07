module eight_x_eight_tb;
    parameter int DATA_WIDTH = 8;
    parameter int ACC_WIDTH = 32;

    logic clk = 1'b0;
    logic rst;
    logic enable;
    logic input_write;
    logic output_write;
    logic output_read;
    logic[2:0] row_ptr;
    logic signed [DATA_WIDTH-1:0] b_in[8];

    logic signed [DATA_WIDTH-1:0] a_in[8];
    logic signed [ACC_WIDTH-1:0] c_out[8];

    eight_x_eight #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) dut (.*);

    initial begin: generate_clk
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
    logic signed[DATA_WIDTH-1:0] a_flattened[64];
    logic signed[DATA_WIDTH-1:0] a_matrix[8][8];
    logic signed[DATA_WIDTH-1:0] b_flattened[64];
    logic signed[DATA_WIDTH-1:0] b_matrix[8][8];

    initial begin
        $readmemh("test_A.txt", a_flattened);
        $readmemh("test_B.txt", b_flattened);

        for(int i = 0; i < 8; i++) begin
            for(int j = 0; j < 8; j++) begin
                a_matrix[i][j] = a_flattened[i*8 + j];
                b_matrix[i][j] = b_flattened[i*8 + j];
            end
        end
    end
    initial begin
        rst <= 1;
        enable <= 0;
        input_write <= 0;
        output_write <= 0;
        output_read <= 0;
        row_ptr <= 0;
        @(posedge clk);
        rst <= 0;
        @(posedge clk);

        //load a and b matrices
        for(int i = 0; i < 8; i++) begin
            for(int j = 0; j < 8; j++) begin
                a_in[j] <= a_matrix[j][i];
                b_in[j] <= b_matrix[j][i];
            end
            input_write <= 1;
            row_ptr <= i;
            @(posedge clk);
        end
        input_write <= 0;
        
        //begin computation
        enable <= 1;
        repeat(8) @(posedge clk);

        //begin writing to output buffer
        output_write <= 1;
        repeat(15) @(posedge clk);

        //begin reading output buffer
        output_write <= 0;
        output_read <= 1;
        repeat(8) @(posedge clk);
        disable generate_clk;
    end
endmodule
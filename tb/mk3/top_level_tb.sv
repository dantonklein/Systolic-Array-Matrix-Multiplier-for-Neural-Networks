module top_level_tbmk3;
    logic clk;
    logic rst;

    logic start;
    logic done;
    logic ready;

    logic a_wr_en;
    logic a_full;
    logic [127:0] a_fifo_in;

    logic b_wr_en;
    logic b_full;
    logic [127:0] b_fifo_in;

    logic c_valid;
    logic c_ready;
    logic signed [31:0] c_out[16];

    systolic_array_mat_mult_16x16mk3 DUT (.*);

    initial begin: generate_clk
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
    logic signed[7:0] a_flattened[256];
    logic signed[127:0] a_matrix[16];
    logic signed[7:0] b_flattened[256];
    logic signed[127:0] b_matrix[16];
    initial begin
        $readmemh("test_A.hex", a_flattened);
        $readmemh("test_B.hex", b_flattened);
        for(int i = 0; i < 16; i++) begin
            b_matrix[i] = '0;
            a_matrix[i] = '0;
            for(int j = 0; j < 16; j++) begin
                b_matrix[i][j*8 +: 8] = b_flattened[i + j*16];
                a_matrix[i][j*8 +: 8] = a_flattened[i + j*16];
            end
        end
    end

    initial begin
        rst <= 1;
        start <= 0;
        a_wr_en <= 0;
        b_wr_en <= 0;
        c_ready <= 0;
        @(posedge clk);
        rst <= 0;
        repeat(2) @(posedge clk);
        for(int i = 0; i < 16; i++) begin
            a_fifo_in <= a_matrix[i];
            b_fifo_in <= b_matrix[i];
            a_wr_en <= 1;
            b_wr_en <= 1;
            @(posedge clk);
        end
        a_wr_en <= 0;
        b_wr_en <= 0;
        @(posedge clk);
        start <= 1;
        @(posedge clk);
        start <= 0;
        
        @(posedge done);
        c_ready <= 1;
        repeat(20) @(posedge clk);
        disable generate_clk;
    end
endmodule
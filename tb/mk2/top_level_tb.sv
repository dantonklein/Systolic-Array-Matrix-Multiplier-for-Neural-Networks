module top_level_tb;
    logic clk;
    logic rst;

    logic start;
    logic done;
    logic ready;

    logic a_valid;
    logic a_ready;
    logic signed [7:0] a_in[8];

    logic b_valid;
    logic b_ready;
    logic signed [7:0] b_in[8];

    logic c_valid;
    logic c_ready;
    logic signed [31:0] c_out[8];

    systolic_array_mat_mult_8x8 DUT (.*);

    initial begin: generate_clk
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
    logic signed[7:0] a_flattened[64];
    logic signed[7:0] a_matrix[8][8];
    logic signed[7:0] b_flattened[64];
    logic signed[7:0] b_matrix[8][8];

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
        start <= 0;
        a_valid <= 0;
        b_valid <= 0;
        c_ready <= 0;
        @(posedge clk);
        rst <= 0;
        @(posedge clk);
        start <= 1;
        @(posedge clk);
        start <= 0;
        a_valid <= 1;
        b_valid <= 1;
        for(int i = 0; i < 8; i++) begin
            for(int j = 0; j < 8; j++) begin
                a_in[j] <= a_matrix[j][i];
                b_in[j] <= b_matrix[j][i];
            end
            @(posedge clk);
        end
        @(posedge done);
        c_ready <= 1;
        repeat(9) @(posedge clk);
        disable generate_clk;
    end
endmodule
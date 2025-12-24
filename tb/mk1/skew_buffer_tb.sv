module skew_buffer_tb;
    parameter int DATA_WIDTH = 8;
    parameter int ARRAY_SIZE = 8;

    logic clk = 1'b0;
    logic rst;
    logic enable;
    logic signed [DATA_WIDTH-1:0] data_in [ARRAY_SIZE-1:0];
    logic signed [DATA_WIDTH-1:0] data_out [ARRAY_SIZE-1:0];

    skew_buffer #(.DATA_WIDTH(DATA_WIDTH), .ARRAY_SIZE(ARRAY_SIZE)) dut (.*);

    initial begin: generate_clk
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
    
    initial begin
        rst <= 1;
        enable <= 0;

        @(posedge clk);
        rst <= 0;
        @(posedge clk);

        for(int i = 0; i < ARRAY_SIZE; i++) begin
            data_in[i] <= i;
        end
        enable <= 1;

        repeat(9) @(posedge clk);
        disable generate_clk;
    end
endmodule
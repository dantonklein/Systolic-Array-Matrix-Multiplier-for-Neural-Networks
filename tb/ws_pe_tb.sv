module ws_pe_tb;
    parameter int DATA_WIDTH = 8;
    parameter int ACC_WIDTH = 32;

    logic clk = 1'b0;
    logic rst;
    logic enable;
    logic b_load;
    logic signed [DATA_WIDTH-1:0] b_in;
    logic signed [DATA_WIDTH-1:0] a_in;
    logic signed [DATA_WIDTH-1:0] a_out;
    logic signed [ACC_WIDTH-1:0] c_in;
    logic signed [ACC_WIDTH-1:0] c_out;

    ws_pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) dut (.*);

    initial begin: generate_clk
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end

    initial begin
        rst <= 1;
        enable <= 0;
        b_load <= 0;
        b_in <= 0;
        a_in <= 0;
        c_in <= 0;

        repeat(2) @(posedge clk);
        rst <= 0;
        @(posedge clk);

        // Test 1: Load weight b = 5
        $display("Test 1: Loading weight = 5");
        b_load <= 1;
        b_in <= 5;
        @(posedge clk);
        b_load <= 0;
        @(posedge clk);

        // Test 2: MAC with a=2, c_in=10
        $display("Test 2: MAC with a=2, c_in=10");
        enable <= 1;
        a_in <= 2;
        c_in <= 10;
        @(posedge clk);

        // Test 3: MAC with negative values a=-4, c_in=15
        $display("Test 3: MAC with a=-4, c_in=15");
        a_in <= -4;
        c_in <= 15;
        repeat(2) @(posedge clk);

        disable generate_clk;
    end
endmodule
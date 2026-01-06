module skew_buffer_tb2;
    parameter int DATA_WIDTH = 8;
    parameter int ARRAY_SIZE = 4;

    logic clk = 1'b0;
    logic rst;
    logic enable;
    logic write;

    logic[$clog2(ARRAY_SIZE)-1:0] row_ptr;
    logic signed [DATA_WIDTH-1:0] data_in [ARRAY_SIZE-1:0];
    logic signed [DATA_WIDTH-1:0] data_out [ARRAY_SIZE-1:0];

    skew_buffer2 #(.DATA_WIDTH(DATA_WIDTH), .ARRAY_SIZE(ARRAY_SIZE)) dut (.*);

    initial begin: generate_clk
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
    
    initial begin
        rst <= 1;
        enable <= 0;
        write <= 0;
        @(posedge clk);
        rst <= 0;
        @(posedge clk);

        //write to the buffer
        for(int i = 0; i < ARRAY_SIZE; i++) begin
            for(int j = 0; j < ARRAY_SIZE; j++) begin
                data_in[j] <= j + i*ARRAY_SIZE;
            end
            write <= 1;
            row_ptr <= i;

            @(posedge clk);
        end

        //being reading from the buffer
        write <= 0;
        enable <= 1;

        //test deasserting enable
        @(posedge clk);
        enable <= 0;

        @(posedge clk);
        enable <= 1;
        repeat(7) @(posedge clk);
        disable generate_clk;
    end
endmodule

module reverse_skew_buffer_tb2;
    parameter int DATA_WIDTH = 32;
    parameter int ARRAY_SIZE = 4;

    logic clk = 1'b0;
    logic rst;
    logic enable;
    logic write;
    logic read;

    logic signed [DATA_WIDTH-1:0] data_in [ARRAY_SIZE-1:0];
    logic signed [DATA_WIDTH-1:0] data_out [ARRAY_SIZE-1:0];

    reverse_skew_buffer #(.DATA_WIDTH(DATA_WIDTH), .ARRAY_SIZE(ARRAY_SIZE)) dut (.*);

    initial begin: generate_clk
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
    
    initial begin
        rst <= 1;
        enable <= 0;
        write <= 0;
        read <= 0;
        @(posedge clk);
        rst <= 0;
        @(posedge clk);

        write <= 1;
        enable <= 1;

        //write to the buffer
        for(int i = 0; i < 2 * ARRAY_SIZE-1; i++) begin
            for(int j = 0; j < ARRAY_SIZE; j++) begin
                data_in[j] <= i + 1;
            end
            @(posedge clk);
        end

        //being reading from the buffer
        write <= 0;
        enable <= 0;
        read <= 1;

        repeat(4) @(posedge clk);

        read <= 0;
        @(posedge clk);
        disable generate_clk;
    end
endmodule
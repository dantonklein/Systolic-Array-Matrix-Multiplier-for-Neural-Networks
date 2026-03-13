module accum_reg_tb;
    parameter int ARRAY_SIZE = 4;
    parameter int DATA_WIDTH = 32;

    logic clk = 1'b0;
    logic rst;
    logic data_valid;
    logic k_tile_last;
    logic k_tile_first;

    logic valid;
    logic done;
    logic ready;

    logic signed [DATA_WIDTH-1:0] data_in [ARRAY_SIZE];
    logic signed [DATA_WIDTH-1:0] data_out [ARRAY_SIZE];

    accumulation_register #(.DATA_WIDTH(DATA_WIDTH), .ARRAY_SIZE(ARRAY_SIZE)) dut (.*);

    initial begin: generate_clk
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end

    initial begin
        rst <= 1;
        data_valid <= 0;
        k_tile_last <= 0;
        clear <= 0;
        read <= 0;
        @(posedge clk);
        rst <= 0;
        @(posedge clk);

        //load registers with first k tile
        for(int i = 0; i < ARRAY_SIZE; i++) begin
            for(int j = 0; j < ARRAY_SIZE; j++) begin
                data_in[j] <= i + 1;
            end
            data_valid <= 1;
            k_tile_first <= 1;

            @(posedge clk);
        end

        //load another tile
        for(int i = 0; i < ARRAY_SIZE; i++) begin
            for(int j = 0; j < ARRAY_SIZE; j++) begin
                data_in[j] <= i + 1;
            end
            data_valid <= 1;
            k_tile_first <= 0;

            @(posedge clk);
        end

        //load last tile
        for(int i = 0; i < ARRAY_SIZE; i++) begin
            for(int j = 0; j < ARRAY_SIZE; j++) begin
                data_in[j] <= i + 1;
            end
            data_valid <= 1;
            k_tile_last <= 1;

            @(posedge clk);
        end

        //time to read
        for(int i = 0; i < ARRAY_SIZE; i++) begin
            data_valid <= 0;
            read <= 1;

            @(posedge clk);
        end

        read <= 0;
        @(posedge clk);
    end
endmodule
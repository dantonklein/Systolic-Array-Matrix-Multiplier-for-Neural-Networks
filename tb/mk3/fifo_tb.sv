module fifo_tb #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 8
);
    logic             clk;
    logic             rst;
    logic             full;
    logic             wr_en;
    logic [WIDTH-1:0] wr_data;
    logic             empty;
    logic             rd_en;
    logic [WIDTH-1:0] rd_data;

    fifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) DUT (.*);

    initial begin : generate_clock
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end

    initial begin
        rst     <= 1'b1;
        rd_en   <= 1'b0;
        wr_en   <= 1'b0;
        wr_data <= '0;
        repeat (5) @(posedge clk);
        @(negedge clk);
        rst <= 1'b0;

        for (int i = 0; i < 30; i++) begin
            wr_data <= $urandom;
            wr_en   <= $urandom;
            rd_en   <= $urandom;
            @(posedge clk);
        end

        disable generate_clock;
        $display("Tests Completed.");
    end

endmodule
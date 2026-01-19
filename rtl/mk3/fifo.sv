module fifo
	#(
	parameter int WIDTH = 128,
	parameter int DEPTH = 64
	)
	(
	input logic clk,
	input logic rst,
	output logic full,
	input logic wr_en,
	input logic [WIDTH-1:0] wr_data,
	output logic empty,
	input logic rd_en,
	output logic [WIDTH-1:0] rd_data,
    output logic [$clog2(DEPTH):0] count
	);
	
	localparam int READ_LATENCY = 1;
	
	logic [WIDTH-1:0] ram[DEPTH];
	logic [$clog2(DEPTH)-1:0] wr_addr_r, rd_addr_r;
	logic [$clog2(DEPTH):0] count_r;
	logic valid_wr, valid_rd;
	
	always_ff @(posedge clk) begin
		if(valid_wr) ram[wr_addr_r] <= wr_data;
		rd_data <= ram[rd_addr_r];
	end	
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			rd_addr_r <= '0;
			wr_addr_r <= '0;
			count_r <= '0;
		end
		else begin
			if(valid_wr) begin
				wr_addr_r <= wr_addr_r + 1'b1;
				count_r = count_r + 1'b1;
			end
			if(valid_rd) begin
				rd_addr_r <= rd_addr_r + 1'b1;
				count_r <= count_r - 1'b1;
			end
		end
	end
	
	assign valid_wr = wr_en && !full;
	assign valid_rd = rd_en && !empty;
	
	assign full = count_r == DEPTH;
	assign empty = count_r == 0;
	assign count = count_r;
endmodule

module skew_buffer #(
    parameter ARRAY_SIZE = 8,
    parameter DATA_WIDTH = 8
)(
    input  logic clk,
    input  logic rst,
    input  logic enable, 
    
    input var logic signed [DATA_WIDTH-1:0] data_in [ARRAY_SIZE],
    output var logic signed [DATA_WIDTH-1:0] data_out [ARRAY_SIZE]
);
//triangular delay buffer where the Nth buffer has N cycles of delay
//row 0
assign data_out[0] = data_in[0];

//rows 1 through array_size-1
generate
    for (genvar row = 1; row < ARRAY_SIZE; row++) begin
        logic signed [DATA_WIDTH-1:0] delay_array [row];

        always_ff @(posedge clk or posedge rst) begin
            if(rst) begin
                for (int i = 0; i < row; i++) begin
                    delay_array[i] <= '0;
                end
            end else if(enable) begin
                delay_array[0] <= data_in[row];
                for(int i = 1; i < row; i++) begin
                    delay_array[i] <= delay_array[i-1];
                end
            end
        end
        assign data_out[row] = delay_array[row-1];
    end
endgenerate


endmodule
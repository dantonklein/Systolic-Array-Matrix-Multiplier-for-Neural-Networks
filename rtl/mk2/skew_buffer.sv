module skew_buffer2 #(
    parameter ARRAY_SIZE = 8,
    parameter DATA_WIDTH = 8
)(
    input logic clk,
    input logic rst,
    input logic enable, //for reading
    input logic write, //for writing
    
    input logic[$clog2(ARRAY_SIZE)-1:0] row_ptr,
    //columns are written 
    input var logic signed [DATA_WIDTH-1:0] data_in [ARRAY_SIZE],
    output var logic signed [DATA_WIDTH-1:0] data_out [ARRAY_SIZE]
);
//matrix to hold the A matrix, which is rotated
logic[DATA_WIDTH-1:0] rotated_a_buffer[ARRAY_SIZE][ARRAY_SIZE];
logic[ARRAY_SIZE] read_row;

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        for(int i = 0; i < ARRAY_SIZE; i++) begin
            for(int j = 0; j < ARRAY_SIZE; j++) begin
                rotated_a_buffer[i][j] <= 0;
            end
            read_row[i] <= 0;
        end
    end else begin
        if(write) begin
            //reset reading flags
            read_row[0] <= 1;
            for(int i = 1; i < ARRAY_SIZE; i++) begin
                read_row[i] <= 0;
            end
            //write to a line specified by the pointer
            for(int j = 0; j < ARRAY_SIZE; j++) begin
                rotated_a_buffer[row_ptr][ARRAY_SIZE-1-j] <= data_in[j];
            end
        end else if(enable) begin
            for(int i = 0; i < ARRAY_SIZE-1; i++) begin
                read_row[i+1] <= read_row[i];
            end
            for(int i = 0; i < ARRAY_SIZE; i++) begin
                if(read_row[i]) begin
                    for(int j = 0; j < ARRAY_SIZE-1; j++) begin
                        rotated_a_buffer[i][j] <= rotated_a_buffer[i][j+1];
                    end
                end
            end
        end

    end
end

always_comb begin
    for(int i = 0; i < ARRAY_SIZE; i++) begin
        if(read_row[i]) begin //this if statement is probably not necessary gonna test it later
            data_out[i] = rotated_a_buffer[i][0];
        end
        else begin
            data_out[i] = 0;
        end
    end
end

endmodule
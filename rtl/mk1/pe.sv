//weight-stationary processing element

//calculating C = A x B, where B is a stationary weight

module ws_pe #(
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic enable,

    //would be the weights in an ai context
    input logic b_load,
    input logic signed [DATA_WIDTH-1:0] b_in,

    input logic signed [DATA_WIDTH-1:0] a_in,
    output logic signed [DATA_WIDTH-1:0] a_out,

    input logic signed [ACC_WIDTH-1:0] c_in,
    output logic signed [ACC_WIDTH-1:0] c_out
);

logic signed [DATA_WIDTH-1:0] b_r; //register that holds the B matrix elements

//load weight
always_ff @(posedge clk or posedge rst) begin
    if(rst) b_r <= '0;
    else if(b_load) b_r <= b_in;
end

//multiply accumulate
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        a_out <= '0;
        c_out <= '0;
    end else if(enable) begin
        a_out <= a_in;
        c_out <= c_in + (a_in * b_r);
    end
end

endmodule
//i have the assumption that both A and B are available at the same time

module controller (
    input logic clk,
    input logic rst,

    input logic start,
    output logic done,
    output logic ready,

    //control signals for future a buffer
    input logic a_valid,
    output logic a_ready,

    //control signals for future b buffer
    input logic b_valid,
    output logic b_ready,

    //control signals
    output logic enable,
    output logic input_write,
    output logic output_write,
    //output logic output_read, this would be controlled by external peripheral
    output logic[2:0] row_ptr,

    //control signals for future c buffer
    output logic c_valid
    //input logic c_ready, this would be handled by top level, controlled by external peripheral(testbench)
);
    typedef enum logic [2:0] {
        IDLE,
        LOAD,
        COMPUTE,
        DRAIN,
        DONE
    } state_t;

    state_t state_r, next_state;

    logic data_ready_r;

    logic[2:0] ab_counter_r, c_counter_r;
    logic[2:0] next_ab_counter, next_c_counter;

    logic[3:0] c_buffer_counter_r;
    logic[3:0] next_c_buffer_counter;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state_r <= IDLE;
            ab_counter_r <= 0;
            c_counter_r <= 0;
            c_buffer_counter_r <= 0;
        end
        else begin
            state_r <= next_state;
            ab_counter_r <= next_ab_counter;
            c_counter_r <= next_c_counter;
            c_buffer_counter_r <= next_c_buffer_counter;
        end
    end

    always_comb begin
        done = 0;
        ready = 0;

        a_ready = 0;
        b_ready = 0;

        enable = 0;
        input_write = 0;
        output_write = 0;
        //output_read = 0;

        next_state = state_r;
        next_ab_counter = ab_counter_r;
        next_c_counter = c_counter_r;
        next_c_buffer_counter = c_buffer_counter_r;

        case(state_r)
            IDLE: begin
                next_ab_counter = 0;
                next_c_counter = 0;
                next_c_buffer_counter = 0;
                ready = 1;
                if(start) next_state = LOAD;
            end
            LOAD: begin
                a_ready = 1;
                b_ready = 1;
                if(a_valid && b_valid) begin
                    next_ab_counter = ab_counter_r + 1'b1;
                    input_write = 1;
                end else input_write = 0;
                //counter resets upon overflow
                if(ab_counter_r == 3'b111) next_state = COMPUTE;
            end
            COMPUTE: begin
                enable = 1;
                next_c_counter = c_counter_r + 1'b1;
                //counter resets upon overflow
                if(c_counter_r == 3'b111) next_state = DRAIN;
            end
            DRAIN: begin
                enable = 1;
                output_write = 1;
                next_c_buffer_counter = c_buffer_counter_r + 1'b1;
                if(c_buffer_counter_r == 4'd14) next_state = DONE;
            end
            DONE: begin
                next_c_buffer_counter = 0;
                done = 1;
                ready = 1;
                next_state = IDLE;
            end
        endcase
    end

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            data_ready_r <= 0;
        end else begin
            if(next_state == DONE) begin
                data_ready_r <= 1;
            end else if(next_state == DRAIN) begin
                data_ready_r <= 0;
            end
        end
    end
    assign row_ptr = ab_counter_r;
    assign c_valid = data_ready_r;
    
endmodule
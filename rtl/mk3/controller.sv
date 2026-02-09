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
    input logic[8:0] a_count, 

    //control signals for future b buffer
    input logic b_valid,
    output logic b_ready,
    input logic[8:0] b_count,

    //control signals
    output logic enable,
    output logic input_write,
    output logic output_write,
    //output logic output_read, this would be controlled by external peripheral
    output logic[3:0] row_ptr,

    //control signals for future c buffer
    input logic read_valid,
    output logic c_valid
    //input logic c_ready, this would be handled by top level, controlled by external peripheral(testbench)
);
    typedef enum logic [1:0] {
        IDLE,
        COMPUTE,
        DRAIN,
        DONE
    } state_t;

    state_t state_r, next_state;

    logic data_ready_r;

    logic[4:0] compute_counter_r;
    logic[4:0] next_compute_counter;

    logic[4:0] c_buffer_counter_r;
    logic[4:0] next_c_buffer_counter;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state_r <= IDLE;
            compute_counter_r <= 0;
            c_buffer_counter_r <= 0;
        end
        else begin
            state_r <= next_state;
            compute_counter_r <= next_compute_counter;
            c_buffer_counter_r <= next_c_buffer_counter;
        end
    end

    logic fire;
    assign fire = a_valid && b_valid && a_ready && b_ready;

    //for vivado
    // (* max_fanout = 32*)
    //for quartus
    (* maxfan = 32*)
    logic enable_r;

    logic enable_pre_reg;
    always_ff @(posedge clk) begin
        enable_r <= enable_pre_reg;
    end

    assign enable = enable_r;

    always_comb begin
        done = 0;
        ready = 0;

        a_ready = 0;
        b_ready = 0;

        enable_pre_reg = 0;
        input_write = 0;
        output_write = 0;

        next_state = state_r;
        next_compute_counter = compute_counter_r;
        next_c_buffer_counter = c_buffer_counter_r;

        case(state_r)
            IDLE: begin
                next_compute_counter = 0;
                next_c_buffer_counter = 0;
                ready = 1;
                if(start && (a_count > 15) && (b_count > 15)) begin
                    next_state = COMPUTE;
                    a_ready = 1;
                    b_ready = 1;
                end
            end
            COMPUTE: begin //17 cycles

                if(compute_counter_r < 15) begin
                    a_ready = 1;
                    b_ready = 1;
                end

                if(compute_counter_r < 16) begin
                    next_compute_counter = compute_counter_r + 1'b1;
                    input_write = 1;
                    enable_pre_reg = 1;
                end

                if(compute_counter_r == 16) begin //writing is finished
                    enable_pre_reg = 1;
                    next_state = DRAIN;
                end
            end
            DRAIN: begin //31 cycles
                output_write = 1;
                next_c_buffer_counter = c_buffer_counter_r + 1'b1;
                if(c_buffer_counter_r == 5'd30) begin 
                    next_state = DONE;
                    enable_pre_reg = 0;
                end else begin
                    enable_pre_reg = 1;
                end
            end
            DONE: begin //1 cycle
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
    assign row_ptr = compute_counter_r[3:0];
    assign c_valid = data_ready_r & read_valid;
    
endmodule
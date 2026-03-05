`timescale 1ns/1ps

module counter_tb;

reg clock;
reg reset;
reg one_minute;
reg load_new_c;

reg [3:0] new_current_time_ls_hr;
reg [3:0] new_current_time_ls_min;
reg [3:0] new_current_time_ms_hr;
reg [3:0] new_current_time_ms_min;

wire [3:0] current_time_ls_hr;
wire [3:0] current_time_ls_min;
wire [3:0] current_time_ms_hr;
wire [3:0] current_time_ms_min;

// DUT

counter uut (
    .clock(clock),
    .reset(reset),
    .one_minute(one_minute),
    .load_new_c(load_new_c),
    .new_current_time_ls_hr(new_current_time_ls_hr),
    .new_current_time_ls_min(new_current_time_ls_min),
    .new_current_time_ms_hr(new_current_time_ms_hr),
    .new_current_time_ms_min(new_current_time_ms_min),
    .current_time_ls_hr(current_time_ls_hr),
    .current_time_ls_min(current_time_ls_min),
    .current_time_ms_hr(current_time_ms_hr),
    .current_time_ms_min(current_time_ms_min)
);

// Clock

always #5 clock = ~clock;

initial begin

    $dumpfile("counter.vcd");
    $dumpvars(0,counter_tb);

    clock = 0;
    reset = 1;
    one_minute = 0;
    load_new_c = 0;

    #20
    reset = 0;

    // Load time = 23:58

    new_current_time_ms_hr = 2;
    new_current_time_ls_hr = 3;
    new_current_time_ms_min = 5;
    new_current_time_ls_min = 8;

    load_new_c = 1;
    #10
    load_new_c = 0;

    // minute tick → 23:59

    #20
    one_minute = 1;
    #10
    one_minute = 0;

    // minute tick → 00:00

    #20
    one_minute = 1;
    #10
    one_minute = 0;

    // simulate few more minutes

    repeat(5) begin
        #20
        one_minute = 1;
        #10
        one_minute = 0;
    end

    #50
    $finish;

end

endmodule
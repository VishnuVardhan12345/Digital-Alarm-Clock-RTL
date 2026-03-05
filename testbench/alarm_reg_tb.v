`timescale 1ns/1ps

module alarm_reg_tb;

reg clock;
reg reset;
reg load_new_a;

reg [3:0] new_alarm_time_ms_hr;
reg [3:0] new_alarm_time_ls_hr;
reg [3:0] new_alarm_time_ms_min;
reg [3:0] new_alarm_time_ls_min;

wire [3:0] alarm_time_ms_hr;
wire [3:0] alarm_time_ls_hr;
wire [3:0] alarm_time_ms_min;
wire [3:0] alarm_time_ls_min;

alarm_reg uut (

    .new_alarm_time_ms_hr(new_alarm_time_ms_hr),
    .new_alarm_time_ls_hr(new_alarm_time_ls_hr),
    .new_alarm_time_ms_min(new_alarm_time_ms_min),
    .new_alarm_time_ls_min(new_alarm_time_ls_min),

    .load_new_a(load_new_a),
    .clock(clock),
    .reset(reset),

    .alarm_time_ms_hr(alarm_time_ms_hr),
    .alarm_time_ls_hr(alarm_time_ls_hr),
    .alarm_time_ms_min(alarm_time_ms_min),
    .alarm_time_ls_min(alarm_time_ls_min)

);

// clock generation

always #5 clock = ~clock;

initial begin

    $dumpfile("alarm_reg.vcd");
    $dumpvars(0,alarm_reg_tb);

    clock = 0;
    reset = 1;
    load_new_a = 0;

    #20
    reset = 0;

    // Load alarm time = 06:30

    new_alarm_time_ms_hr = 0;
    new_alarm_time_ls_hr = 6;
    new_alarm_time_ms_min = 3;
    new_alarm_time_ls_min = 0;

    load_new_a = 1;
    #10
    load_new_a = 0;

    #50

    // Load new alarm = 07:45

    new_alarm_time_ms_hr = 0;
    new_alarm_time_ls_hr = 7;
    new_alarm_time_ms_min = 4;
    new_alarm_time_ls_min = 5;

    load_new_a = 1;
    #10
    load_new_a = 0;

    #50
    $finish;

end

endmodule
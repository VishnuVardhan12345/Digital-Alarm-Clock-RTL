`timescale 1ns/1ps

module lcd_driver_4_tb;

// Alarm time inputs
reg [3:0] alarm_time_ms_hr;
reg [3:0] alarm_time_ls_hr;
reg [3:0] alarm_time_ms_min;
reg [3:0] alarm_time_ls_min;

// Current time inputs
reg [3:0] current_time_ms_hr;
reg [3:0] current_time_ls_hr;
reg [3:0] current_time_ms_min;
reg [3:0] current_time_ls_min;

// Key inputs
reg [3:0] key_ms_hr;
reg [3:0] key_ls_hr;
reg [3:0] key_ms_min;
reg [3:0] key_ls_min;

// Control signals
reg show_a;
reg show_current_time;

// Outputs
wire [7:0] display_ms_hr;
wire [7:0] display_ls_hr;
wire [7:0] display_ms_min;
wire [7:0] display_ls_min;

wire sound_a;

// Instantiate DUT
lcd_driver_4 uut (
    alarm_time_ms_hr, alarm_time_ls_hr,
    alarm_time_ms_min, alarm_time_ls_min,

    current_time_ms_hr, current_time_ls_hr,
    current_time_ms_min, current_time_ls_min,

    key_ms_hr, key_ls_hr,
    key_ms_min, key_ls_min,

    show_a, show_current_time,

    display_ms_hr, display_ls_hr,
    display_ms_min, display_ls_min,

    sound_a
);

initial begin

    $dumpfile("lcd_driver_4.vcd");
    $dumpvars(0,lcd_driver_4_tb);

    // Initial values
    show_a = 0;
    show_current_time = 0;

    // Current time = 12:34
    current_time_ms_hr = 4'd1;
    current_time_ls_hr = 4'd2;
    current_time_ms_min = 4'd3;
    current_time_ls_min = 4'd4;

    // Alarm time = 12:34
    alarm_time_ms_hr = 4'd1;
    alarm_time_ls_hr = 4'd2;
    alarm_time_ms_min = 4'd3;
    alarm_time_ls_min = 4'd4;

    // Key values
    key_ms_hr = 4'd0;
    key_ls_hr = 4'd9;
    key_ms_min = 4'd5;
    key_ls_min = 4'd7;

    #20;

    // Test alarm display
    show_a = 1;
    #20;

    show_a = 0;

    // Test key entry display
    show_current_time = 1;
    #20;

    show_current_time = 0;

    #40;

    $finish;

end

endmodule
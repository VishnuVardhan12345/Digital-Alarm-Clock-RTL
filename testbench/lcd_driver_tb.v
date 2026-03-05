`timescale 1ns/1ps

module lcd_driver_tb;

reg [3:0] key;
reg [3:0] alarm_time;
reg [3:0] current_time;
reg show_alarm;
reg show_new_time;

wire [7:0] display_time;
wire sound_alarm;

lcd_driver uut (
    .alarm_time(alarm_time),
    .current_time(current_time),
    .show_alarm(show_alarm),
    .show_new_time(show_new_time),
    .key(key),
    .display_time(display_time),
    .sound_alarm(sound_alarm)
);

initial begin

$dumpfile("lcd_driver.vcd");
$dumpvars(0,lcd_driver_tb);

key = 0;
alarm_time = 0;
current_time = 0;
show_alarm = 0;
show_new_time = 0;

#20

// Test 1: show current time
current_time = 4'd5;

#20

// Test 2: show alarm time
alarm_time = 4'd7;
show_alarm = 1;

#20
show_alarm = 0;

// Test 3: show new key input
key = 4'd3;
show_new_time = 1;

#20
show_new_time = 0;

// Test 4: alarm trigger
current_time = 4'd9;
alarm_time = 4'd9;

#20

$finish;

end

endmodule
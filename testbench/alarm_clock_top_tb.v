`timescale 1ns/1ps

module alarm_clock_top_tb;

// Inputs
reg clock;
reg reset;
reg time_button;
reg alarm_button;
reg fastwatch;
reg [3:0] key;

// Outputs
wire [7:0] ms_hour;
wire [7:0] ls_hour;
wire [7:0] ms_minute;
wire [7:0] ls_minute;
wire alarm_sound;


alarm_clock_top uut (
    .clock(clock),
    .key(key),
    .reset(reset),
    .time_button(time_button),
    .alarm_button(alarm_button),
    .fastwatch(fastwatch),
    .ms_hour(ms_hour),
    .ls_hour(ls_hour),
    .ms_minute(ms_minute),
    .ls_minute(ls_minute),
    .alarm_sound(alarm_sound)
);

// Clock generation
always #5 clock = ~clock;

initial begin

$dumpfile("alarm_clock_top.vcd");
$dumpvars(0,alarm_clock_top_tb);

// Initial values
clock = 0;
reset = 1;
key = 4'd10;      // no key
time_button = 0;
alarm_button = 0;
fastwatch = 0;    // start with normal clock

//------------------------------------------------
// RESET PHASE
//------------------------------------------------

#50;
reset = 0;

// Let clock run normally
#200;


//------------------------------------------------
// CASE 1 : USER TAKES TOO LONG (TIMEOUT TEST)
//------------------------------------------------

// press one digit
#20 key = 4'd4;
#20 key = 4'd10;

// wait long time → FSM timeout should occur
#600;

// try next digit
#20 key = 4'd2;
#20 key = 4'd10;

// this entry should be ignored because FSM
// should have returned to show_time

#25000;


//------------------------------------------------
// CASE 2 : SET CURRENT TIME = 12:34
//------------------------------------------------

#20 key = 4'd1;  #20 key = 4'd10;
#20 key = 4'd2;  #20 key = 4'd10;
#20 key = 4'd3;  #20 key = 4'd10;
#20 key = 4'd4;  #20 key = 4'd10;

// store current time
#20 time_button = 1;
#20 time_button = 0;


//------------------------------------------------
// CASE 3 : SET ALARM TIME = 12:36
//------------------------------------------------

#50 key = 4'd1;  #20 key = 4'd10;
#20 key = 4'd2;  #20 key = 4'd10;
#20 key = 4'd3;  #20 key = 4'd10;
#20 key = 4'd5;  #20 key = 4'd10;

// store alarm
#20 alarm_button = 1;
#20 alarm_button = 0;


//------------------------------------------------
// CASE 4 : ENABLE FAST CLOCK
//------------------------------------------------

#100;
fastwatch = 1;


//------------------------------------------------
// LET CLOCK RUN → ALARM SHOULD TRIGGER
//------------------------------------------------

#5000;


//------------------------------------------------
// END SIMULATION
//------------------------------------------------

$finish;

end

endmodule
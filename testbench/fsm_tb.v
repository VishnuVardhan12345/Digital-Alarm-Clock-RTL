`timescale 1ns/1ps

module fsm_tb;

reg clock;
reg reset;
reg one_second;
reg alarm_button;
reg time_button;
reg [3:0] key;

wire load_new_a;
wire load_new_c;
wire show_new_time;
wire show_a;
wire shift;
wire reset_count;
wire clear_keys;

// Instantiate FSM

fsm uut (
    .clock(clock),
    .reset(reset),
    .one_second(one_second),
    .alarm_button(alarm_button),
    .time_button(time_button),
    .key(key),
    .load_new_c(load_new_c),
    .show_new_time(show_new_time),
    .show_a(show_a),
    .load_new_a(load_new_a),
    .shift(shift),
    .reset_count(reset_count),
    .clear_keys(clear_keys)
);

// Clock generation (10 ns period)

always #5 clock = ~clock;

initial begin

$dumpfile("fsm.vcd");
$dumpvars(0,fsm_tb);

// Initial values
clock = 0;
reset = 1;
alarm_button = 0;
time_button = 0;
key = 4'd10;     // no key
one_second = 0;

#20;
reset = 0;

/////////////////////////////////////////////////
// CASE 1 : USER PRESSES KEY THEN TIMES OUT
/////////////////////////////////////////////////

// press key
#20 key = 4'd3;
#20 key = 4'd10;

// generate one_second pulses to trigger timeout
repeat(12) begin
    #10 one_second = 1;
    #10 one_second = 0;
end

// FSM should return to show_time
// clear_keys should go high


/////////////////////////////////////////////////
// CASE 2 : NORMAL KEY ENTRY
/////////////////////////////////////////////////

#40 key = 4'd1;
#20 key = 4'd10;

#40 key = 4'd2;
#20 key = 4'd10;


/////////////////////////////////////////////////
// CASE 3 : SET CURRENT TIME
/////////////////////////////////////////////////

#40 time_button = 1;
#20 time_button = 0;


/////////////////////////////////////////////////
// CASE 4 : SET ALARM TIME
/////////////////////////////////////////////////

#60 alarm_button = 1;
#20 alarm_button = 0;


/////////////////////////////////////////////////
// GENERATE MORE CLOCK PULSES
/////////////////////////////////////////////////

repeat(20) begin
    #10 one_second = 1;
    #10 one_second = 0;
end

#200;
$finish;

end

endmodule
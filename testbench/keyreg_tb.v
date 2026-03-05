`timescale 1ns/1ps

module keyreg_tb;

reg clock;
reg reset;
reg shift;
reg clear_keys;
reg [3:0] key;

wire [3:0] key_buffer_ms_hr;
wire [3:0] key_buffer_ls_hr;
wire [3:0] key_buffer_ms_min;
wire [3:0] key_buffer_ls_min;

// Instantiate DUT

keyreg uut(
    .clock(clock),
    .reset(reset),
    .shift(shift),
    .clear_keys(clear_keys),
    .key(key),
    .key_buffer_ms_hr(key_buffer_ms_hr),
    .key_buffer_ls_hr(key_buffer_ls_hr),
    .key_buffer_ms_min(key_buffer_ms_min),
    .key_buffer_ls_min(key_buffer_ls_min)
);

// Clock generation
always #5 clock = ~clock;

initial begin

$dumpfile("keyreg.vcd");
$dumpvars(0,keyreg_tb);

// Initial values
clock = 0;
reset = 1;
shift = 0;
clear_keys = 0;
key = 4'd0;

#20 reset = 0;

/////////////////////////////////////////////////
// CASE 1 : NORMAL DIGIT ENTRY
/////////////////////////////////////////////////

#10 key = 4'd1; shift = 1;
#10 shift = 0;

#10 key = 4'd2; shift = 1;
#10 shift = 0;

#10 key = 4'd3; shift = 1;
#10 shift = 0;

#10 key = 4'd4; shift = 1;
#10 shift = 0;

/////////////////////////////////////////////////
// CASE 2 : CLEAR BUFFER (TIMEOUT SIMULATION)
/////////////////////////////////////////////////

#40 clear_keys = 1;
#10 clear_keys = 0;

/////////////////////////////////////////////////
// CASE 3 : NEW ENTRY AFTER CLEAR
/////////////////////////////////////////////////

#20 key = 4'd5; shift = 1;
#10 shift = 0;

#20 key = 4'd6; shift = 1;
#10 shift = 0;

#100 $finish;

end

endmodule
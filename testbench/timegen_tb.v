`timescale 1ns/1ps

module timegen_tb;

reg clock;
reg reset;
reg reset_count;
reg fastwatch;

wire one_second;
wire one_minute;


timegen uut (
    .clock(clock),
    .reset(reset),
    .reset_count(reset_count),
    .fastwatch(fastwatch),
    .one_second(one_second),
    .one_minute(one_minute)
);

// Clock generation (10ns period)

always #5 clock = ~clock;

initial begin
    $dumpfile("timegen.vcd");
    $dumpvars(0, timegen_tb);

    clock = 0;
    reset = 1;
    reset_count = 0;
    fastwatch = 0;

    #20;
    reset = 0;

    #5000;

    // Enable fastwatch
    fastwatch = 1;

    #5000;

    // Reset counter
    reset_count = 1;
    #20;
    reset_count = 0;

    #5000;

    $finish;

end

endmodule
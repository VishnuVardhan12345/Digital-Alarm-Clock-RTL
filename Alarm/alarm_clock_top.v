module alarm_clock_top (
    clock,key,reset,time_button,alarm_button,fastwatch,ms_hour,ls_hour,ms_minute,ls_minute,alarm_sound
);

input clock,reset,time_button,alarm_button,fastwatch;

input [3:0] key;

output [7:0] ms_hour,ls_hour,ms_minute,ls_minute;

output alarm_sound;

wire one_second,one_minute,load_new_c,load_new_a,show_current_time,show_a,shift,reset_count;

wire [3:0] key_buffer_ms_hr,key_buffer_ls_hr,key_buffer_ms_min,key_buffer_ls_min,
            current_time_ms_hr,current_time_ls_hr,current_time_ms_min,current_time_ls_min,
            alarm_time_ms_hr,alarm_time_ls_hr,alarm_time_ms_min,alarm_time_ls_min;

timegen tgen1 (.clock(clock),.reset(reset),.fastwatch(fastwatch),.one_second(one_second),.one_minute(one_minute),.reset_count(reset_count));

counter count1 (
    .one_minute(one_minute),
    .new_current_time_ms_hr(key_buffer_ms_hr),.new_current_time_ls_hr(key_buffer_ls_hr),.new_current_time_ms_min(key_buffer_ms_min),.new_current_time_ls_min(key_buffer_ls_min),
    .load_new_c(load_new_c),.clock(clock),.reset(reset),
    .current_time_ms_hr(current_time_ms_hr),.current_time_ls_hr(current_time_ls_hr),.current_time_ms_min(current_time_ms_min),.current_time_ls_min(current_time_ls_min)
);

alarm_reg alreg1 (
    .new_alarm_time_ms_hr(key_buffer_ms_hr),.new_alarm_time_ls_hr(key_buffer_ls_hr),.new_alarm_time_ms_min(key_buffer_ms_min),.new_alarm_time_ls_min(key_buffer_ls_min),
    .load_new_a(load_new_a),.clock(clock),.reset(reset),
    .alarm_time_ms_hr(alarm_time_ms_hr),.alarm_time_ls_hr(alarm_time_ls_hr),.alarm_time_ms_min(alarm_time_ms_min),.alarm_time_ls_min(alarm_time_ls_min)
);

keyreg keyreg1 (
    .reset(reset),.clock(clock),.shift(shift),.key(key),.clear_keys(clear_keys),
    .key_buffer_ms_hr(key_buffer_ms_hr),.key_buffer_ms_min(key_buffer_ms_min),.key_buffer_ls_hr(key_buffer_ls_hr),.key_buffer_ls_min(key_buffer_ls_min)
);

fsm fsm1 (
    .clock(clock),.one_second(one_second),.reset_count(reset_count),.reset(reset),.alarm_button(alarm_button),.time_button(time_button),.key(key),
    .clear_keys(clear_keys),.load_new_c(load_new_c),.show_new_time(show_current_time),.show_a(show_a),.load_new_a(load_new_a),.shift(shift)
);

lcd_driver_4 lcd_disp (
    .alarm_time_ms_hr(alarm_time_ms_hr),.alarm_time_ls_hr(alarm_time_ls_hr),.alarm_time_ms_min(alarm_time_ms_min),.alarm_time_ls_min(alarm_time_ls_min),
    .current_time_ms_hr(current_time_ms_hr),.current_time_ls_hr(current_time_ls_hr),.current_time_ms_min(current_time_ms_min),.current_time_ls_min(current_time_ls_min),
    .key_ms_hr(key_buffer_ms_hr),.key_ls_hr(key_buffer_ls_hr),.key_ms_min(key_buffer_ms_min),.key_ls_min(key_buffer_ls_min),
    .show_a(show_a),.show_current_time(show_current_time),
    .display_ms_hr(ms_hour),.display_ls_hr(ls_hour),.display_ms_min(ms_minute),.display_ls_min(ls_minute),
    .sound_a(alarm_sound)
);

endmodule
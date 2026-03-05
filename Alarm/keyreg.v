module keyreg (
    reset,clock,shift,key,clear_keys,
    key_buffer_ms_hr,
    key_buffer_ms_min,
    key_buffer_ls_hr,
    key_buffer_ls_min
);

input reset,clock,shift,clear_keys;
input [3:0]key;

output reg [3:0] key_buffer_ms_hr,key_buffer_ms_min,key_buffer_ls_hr,key_buffer_ls_min;

always @(posedge clock or posedge reset) begin
    if (reset||clear_keys) begin
        key_buffer_ls_hr<=0;
        key_buffer_ls_min<=0;
        key_buffer_ms_hr<=0;
        key_buffer_ms_min<=0;
    end
    else if (shift==1) begin
        key_buffer_ms_hr<=key_buffer_ls_hr;
        key_buffer_ls_hr<=key_buffer_ms_min;
        key_buffer_ms_min<=key_buffer_ls_min;
        key_buffer_ls_min<=key;
    end
end

endmodule
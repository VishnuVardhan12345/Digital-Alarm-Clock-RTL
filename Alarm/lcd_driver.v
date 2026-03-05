module lcd_driver (
    alarm_time,current_time,show_alarm,show_new_time,key,display_time,sound_alarm
);

input [3:0]key,alarm_time,current_time;
input show_alarm,show_new_time;

output reg [7:0]display_time ;
output reg sound_alarm;

reg [3:0] display_value ;

parameter zero = 8'h30 ;
parameter one=8'h31;
parameter two=8'h32;
parameter three =8'h33 ;
parameter four =8'h34 ;
parameter five=8'h35;
parameter six=8'h36;
parameter seven=8'h37;
parameter eight=8'h38;
parameter nine=8'h39;
parameter error=8'h3A;

always @(alarm_time or current_time or show_alarm or show_new_time or key) begin
    if (show_new_time) begin
        display_value=key;
    end
    else if (show_alarm) begin
        display_value=alarm_time;
    end
    else begin
        display_value=current_time;
    end

    if (current_time==alarm_time) begin
        sound_alarm=1'b1;
    end
    else begin
        sound_alarm=1'b0;
    end
end


always @(display_value) begin
    case (display_value)
        4'd0: display_time=zero;
        4'd1: display_time=one;
        4'd2: display_time=two;
        4'd3: display_time=three;
        4'd4: display_time=four;
        4'd5: display_time=five;
        4'd6: display_time=six;
        4'd7: display_time=seven;
        4'd8: display_time=eight;
        4'd9: display_time=nine;
        default: display_time=error;
    endcase
end

endmodule
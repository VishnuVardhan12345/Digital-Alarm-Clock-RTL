module fsm (
    one_second,reset_count,clock,reset,alarm_button,time_button,key,load_new_c,show_new_time,show_a,load_new_a,shift,clear_keys
);
    input clock,reset,one_second,alarm_button,time_button;
    input [3:0]key;

    output load_new_a,load_new_c,show_new_time,show_a,shift,reset_count,clear_keys;

    reg [2:0] pre_state,next_state ;

    wire time_out;

    reg [3:0]count1,count2 ;

    parameter show_time = 3'b000 ;
    parameter key_entry =3'b001 ;
    parameter key_stored =3'b010 ;
    parameter show_alarm =3'b011 ;
    parameter set_alarm_time =3'b100 ;
    parameter set_current_time =3'b101 ;
    parameter key_waited =3'b110 ;
    parameter nokey =4'd10 ;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            count1<=4'd0;
        end
        else if (pre_state != key_entry) begin
            count1<=4'd0;
        end
        else if (count1==4'd9) begin
            count1<=4'd0;
        end
        else if (one_second) begin
            count1<=count1+1;
        end
    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            count2<=4'd0;
        end
        else if (pre_state!=key_waited) begin
            count2<=4'd0;
        end
        else if (count2==4'd9) begin
            count2<=4'd0;
        end
        else if (one_second) begin
            count2<=count2+1;
        end
    end
    
    assign time_out=((count1==4'd9)||(count2==4'd9)) ?0:1;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            pre_state<=show_time;
        end else begin
            pre_state<=next_state;
        end
    end

    always @(pre_state or key or alarm_button or time_button or time_out) begin
        case (pre_state)

            show_time: begin
                if (alarm_button) begin
                    next_state=show_alarm;
                end
                else if (key!=nokey) begin
                    next_state=key_stored;
                end
                else
                    next_state=show_time;
            end

            key_stored: next_state=key_waited;

            key_waited: begin
                if (key==nokey) begin
                    next_state=key_entry;
                end
                else if (time_out==0) begin
                    next_state=show_time;
                end
                else
                    next_state=key_waited;
            end

            key_entry: begin
                if (alarm_button) begin
                    next_state=set_alarm_time;
                end
                else if (time_button) begin
                    next_state=set_current_time;
                end
                else if (time_out==0) begin
                    next_state=show_time;
                end
                else if (key!=nokey) begin
                    next_state=key_stored;
                end
                else
                    next_state=key_entry;
            end

            set_alarm_time: next_state=show_time;
            set_current_time: next_state=show_time;

            show_alarm:begin
                if (!alarm_button) begin
                    next_state=show_time;
                end else begin
                    next_state=show_alarm;
                end
            end
            default: next_state = show_time;
        endcase
    end

    assign show_new_time=(pre_state==key_stored || pre_state==key_waited || pre_state==key_entry)? 1:0;
    assign show_a=(pre_state==show_alarm)? 1:0;
    assign load_new_a=(pre_state==set_alarm_time)? 1:0;
    assign load_new_c=(pre_state==set_current_time)? 1:0;
    assign shift=(pre_state==key_stored)? 1:0;
    assign reset_count=(pre_state==set_current_time)? 1:0;
    assign clear_keys = (time_out == 0);
    
endmodule

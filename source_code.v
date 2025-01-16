module aclock (
    input reset,          // Active high reset
    input clk,            // 10Hz clock input
    input [1:0] H_in1,    // Most significant hour digit input
    input [3:0] H_in0,    // Least significant hour digit input
    input [3:0] M_in1,    // Most significant minute digit input
    input [3:0] M_in0,    // Least significant minute digit input
    input LD_time,        // Load time signal
    input LD_alarm,       // Load alarm signal
    input STOP_al,        // Stop alarm signal
    input AL_ON,          // Alarm enable signal
    output reg Alarm,     // Alarm output
    output [1:0] H_out1,  // Most significant hour digit output
    output [3:0] H_out0,  // Least significant hour digit output
    output [3:0] M_out1,  // Most significant minute digit output
    output [3:0] M_out0,  // Least significant minute digit output
    output [3:0] S_out1,  // Most significant second digit output
    output [3:0] S_out0   // Least significant second digit output
);

// Internal signals
reg [3:0] clk_div;        // Clock divider counter for 1s clock
reg clk_1s;               // 1s clock signal
reg [5:0] hour, minute, second;       // Clock time
reg [5:0] alarm_hour, alarm_minute;   // Alarm time

// Generate 1s clock from 10Hz clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        clk_div <= 0;
        clk_1s <= 0;
    end else begin
        if (clk_div == 4) begin // Divide by 10 (10Hz to 1Hz)
            clk_1s <= ~clk_1s;
            clk_div <= 0;
        end else begin
            clk_div <= clk_div + 1;
        end
    end
end

// Clock and alarm time logic
always @(posedge clk_1s or posedge reset) begin
    if (reset) begin
        // Reset all values
        hour <= 0;
        minute <= 0;
        second <= 0;
        alarm_hour <= 0;
        alarm_minute <= 0;
        Alarm <= 0;
    end else begin
        if (LD_time) begin
            // Load clock time
            hour <= (H_in1 * 10) + H_in0;
            minute <= (M_in1 * 10) + M_in0;
            second <= 0;
        end else if (LD_alarm) begin
            // Load alarm time
            alarm_hour <= (H_in1 * 10) + H_in0;
            alarm_minute <= (M_in1 * 10) + M_in0;
        end else begin
            // Increment time
            second <= second + 1;
            if (second == 59) begin
                second <= 0;
                minute <= minute + 1;
                if (minute == 59) begin
                    minute <= 0;
                    hour <= hour + 1;
                    if (hour == 24) begin
                        hour <= 0;
                    end
                end
            end
        end
    end
end

// Alarm logic
always @(posedge clk_1s or posedge reset) begin
    if (reset) begin
        Alarm <= 0;
    end else begin
        if (AL_ON && (hour == alarm_hour) && (minute == alarm_minute) && (second == 0)) begin
            Alarm <= 1; // Trigger alarm
        end
        if (STOP_al) begin
            Alarm <= 0; // Stop alarm
        end
    end
end

// Outputs
assign H_out1 = hour / 10;
assign H_out0 = hour % 10;
assign M_out1 = minute / 10;
assign M_out0 = minute % 10;
assign S_out1 = second / 10;
assign S_out0 = second % 10;

endmodule

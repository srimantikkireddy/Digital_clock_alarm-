`timescale 1ns / 1ps

module aclock_tb;
    // Inputs
    reg reset;
    reg clk;
    reg [1:0] H_in1;
    reg [3:0] H_in0;
    reg [3:0] M_in1;
    reg [3:0] M_in0;
    reg LD_time;
    reg LD_alarm;
    reg STOP_al;
    reg AL_ON;

    // Outputs
    wire Alarm;
    wire [1:0] H_out1;
    wire [3:0] H_out0;
    wire [3:0] M_out1;
    wire [3:0] M_out0;
    wire [3:0] S_out1;
    wire [3:0] S_out0;

    // Instantiate the Unit Under Test (UUT)
    aclock uut (
        .reset(reset),
        .clk(clk),
        .H_in1(H_in1),
        .H_in0(H_in0),
        .M_in1(M_in1),
        .M_in0(M_in0),
        .LD_time(LD_time),
        .LD_alarm(LD_alarm),
        .STOP_al(STOP_al),
        .AL_ON(AL_ON),
        .Alarm(Alarm),
        .H_out1(H_out1),
        .H_out0(H_out0),
        .M_out1(M_out1),
        .M_out0(M_out0),
        .S_out1(S_out1),
        .S_out0(S_out0)
    );

    // Clock generation (10Hz clock, period = 100 ms)
    initial begin
        clk = 0;
        forever #50000000 clk = ~clk; // Toggle every 50ms for a 10Hz clock
    end

    // Testbench logic
    initial begin
        // Initialize all inputs
        reset = 1;       // Assert reset
        H_in1 = 2'b00;   // Initialize hour inputs
        H_in0 = 4'b0000;
        M_in1 = 4'b0000; // Initialize minute inputs
        M_in0 = 4'b0000;
        LD_time = 0;     // Load signals
        LD_alarm = 0;
        STOP_al = 0;     // Alarm control
        AL_ON = 0;

        // Wait for the reset to take effect
        #100;
        reset = 0;       // Deassert reset

        // Load initial time: 12:34
        H_in1 = 2'b01;
        H_in0 = 4'b0010;
        M_in1 = 4'b0011;
        M_in0 = 4'b0100;
        LD_time = 1;     // Load time
        #100;
        LD_time = 0;

        // Wait and observe clock incrementing
        #5000;

        // Load alarm time: 12:35
        H_in1 = 2'b01;
        H_in0 = 4'b0010;
        M_in1 = 4'b0011;
        M_in0 = 4'b0101;
        LD_alarm = 1;    // Load alarm
        #100;
        LD_alarm = 0;

        // Enable alarm
        AL_ON = 1;

        // Observe alarm behavior
        #10000;

        // Stop alarm
        STOP_al = 1;     // Stop alarm signal
        #100;
        STOP_al = 0;

        // Final wait period for observations
        #5000;

        // Finish simulation
        $finish;
    end
endmodule

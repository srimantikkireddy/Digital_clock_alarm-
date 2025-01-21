`timescale 1ns / 1ps

module aclock_tb;
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
    wire Alarm;
    wire [1:0] H_out1;
    wire [3:0] H_out0;
    wire [3:0] M_out1;
    wire [3:0] M_out0;
    wire [3:0] S_out1;
    wire [3:0] S_out0;

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

    initial begin
        clk = 0;
        forever #50000000 clk = ~clk; // Toggle every 50ms for a 10Hz clock
    end

    initial begin
        reset = 1;       
        H_in1 = 2'b00;  
        H_in0 = 4'b0000;
        M_in1 = 4'b0000; 
        M_in0 = 4'b0000;
        LD_time = 0;  
        LD_alarm = 0;
        STOP_al = 0;   
        AL_ON = 0;
        
        #100;
        reset = 0;     

        LD_time = 1;   
        H_in1 = 2'b01;
        H_in0 = 4'b0010;
        M_in1 = 4'b0011;
        M_in0 = 4'b0100;  
        #100;
        LD_time = 0;

        #5000;
        
        LD_alarm = 1;   
        H_in1 = 2'b01;
        H_in0 = 4'b0010;
        M_in1 = 4'b0011;
        M_in0 = 4'b0101;
        #100;
        LD_alarm = 0;

        AL_ON = 1;
        #10000;

        STOP_al = 1;     
        #100;
        STOP_al = 0;

        #5000;
        $finish;
    end
endmodule

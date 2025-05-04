`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Authored by PalmPilot X Team, Habib University
// Created on 1/5/2025
//
// For use with a system input clock signal of 100MHz
//
// Description: This module contains a countdown timer that decrements from a 
// specified parameter value to zero. The module generates a 1Hz clock signal 
// from the 100MHz system clock and uses this to decrement the counter.
// This module outputs the current count value in BCD format, as well as
// the 1Hz signal used for decrementing the counter.
//
////////////////////////////////////////////////////////////////////////////////

module countdown #(parameter count = 4'd5)(
    input clk_100MHz,                   // sys clock
    input reset,                        // reset clock
    output tick_1Hz,                    // 1Hz output signal
    output [3:0] sec_1s
    );
    
	
    // ********************************************************
    // create the 1Hz signal
    reg [31:0] ctr_1Hz = 32'h0;
    reg r_1Hz = 1'b0;
    
    always @(posedge clk_100MHz or posedge reset)
        if(reset)
            ctr_1Hz <= 32'h0;
        else
            if(ctr_1Hz == 49_999_999) begin
                ctr_1Hz <= 32'h0;
                r_1Hz <= ~r_1Hz;
            end
            else
                ctr_1Hz <= ctr_1Hz + 1;
     
    // ********************************************************
    // regs for each time value
    reg [5:0] seconds_ctr=count;   // 
	
	// seconds counter reg control
    always @(posedge tick_1Hz or posedge reset)
        if(reset)
            seconds_ctr <= count;
        else
            if(seconds_ctr != 6'd0)
                seconds_ctr <= seconds_ctr - 1;
            
                    
    // ********************************************************                
    // convert binary values to output bcd values
    assign sec_1s  = seconds_ctr % 10;   
     
    // 1Hz output            
    assign tick_1Hz = r_1Hz; 
            
endmodule
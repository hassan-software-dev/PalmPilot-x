`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Habib University
// Engineer: PalmPilot X Team
// 
// Create Date: 04/30/2025 07:22:12 PM
// Design Name: PalmPilot X
// Module Name: difficulty_selector
// Project Name: PalmPilot X Game Console
// Target Devices: Basys 3
// Tool Versions: Vivado 2020.1
// Description: Module for selecting difficulty level for the game
// 
// Dependencies: switch_pulse module
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Allows user to cycle through difficulty levels using up/down buttons
//////////////////////////////////////////////////////////////////////////////////


module difficulty_selector(
    input clk,
    input reset,
    input [3:0] ir,
    output reg done,
    output reg [1:0] selection
    );
    
     switch_pulse t_switch_pulse (
        .clk(clk),
        .rst(reset),
        .switch_in(ir[1]),
        .pulse_out(move_up)
    );
    switch_pulse b_switch_pulse (
        .clk(clk),
        .rst(0),
        .switch_in(ir[0]),
        .pulse_out(move_down)
    );
    
    
always @(posedge clk or posedge reset) begin
    if (reset) begin
        selection <= 0;
        done <= 0;
    end else begin
        if (~done)
            if (move_up) begin
                if (selection == 0)
                    selection <= 2;
                else
                    selection <= selection - 1;
            end else if (move_down) begin
                if (selection == 2)
                    selection <= 0;
                else
                    selection <= selection + 1;
            end else if (ir[3] && ir[2]) begin
                done <= 1;
            end
    end
end

    
    
endmodule

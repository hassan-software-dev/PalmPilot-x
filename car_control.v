`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Habib University
// Engineer: PalmPilot X Team
// 
// Create Date: 29/04/2025 02:15:30 PM
// Design Name: Car Control Module
// Module Name: car_control
// Project Name: PalmPilot X
// Target Devices: Basys 3 / Nexys A7
// Tool Versions: Vivado 2020.1
// Description: Controller module that processes IR sensor inputs and generates 
//              control signals for car movement
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This module interprets 4-bit sensor input data and produces appropriate 
// 4-bit control signals for the car's movement system
//
//////////////////////////////////////////////////////////////////////////////////


module car_control(
    input [3:0] ir,
    output [3:0] ctrl_signals
    );
    
    assign ctrl_signals[3]= ir [3]&&ir [2]?1:~ir [3];
    assign ctrl_signals[2]= ir [3]&&ir [2]?1:~ir [2];
    assign ctrl_signals[1]= ir [1]&&ir [0]?1:~ir [1];
    assign ctrl_signals[0]= ir [1]&&ir [0]?1:~ir [0];
    
endmodule

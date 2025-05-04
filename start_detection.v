`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Habib University
// Engineer: PalmPilot X Team
// 
// Create Date: 03/05/2025 09:24:00 PM
// Design Name: PalmPilot X
// Module Name: start_detection
// Project Name: PalmPilot X
// Target Devices: Basys3
// Tool Versions: Vivado 2020.1
// Description: Button press detection module for system initialization
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This module detects a button press to start the system and maintains the start
// signal until reset is triggered.
//////////////////////////////////////////////////////////////////////////////////

module start_detection(
    input wire clk,        // Clock signal
    input wire btn,        // Button press signal
    input wire reset,      // Reset signal
    output reg start       // Output signal
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, set start to 0 and clear button state
            start <= 0;
        end else begin
            if (btn && ~start) begin
                start <= 1;
            end 
        end
    end

endmodule

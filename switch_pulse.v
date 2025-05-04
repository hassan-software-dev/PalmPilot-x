`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Habib University
// Engineer: PalmPilot X Team
// 
// Create Date: 04/30/2025 07:35:42 PM
// Design Name: PalmPilot X
// Module Name: switch_pulse
// Project Name: PalmPilot X
// Target Devices: 
// Tool Versions: Vivado 2020.1
// Description: Module that generates a single clock cycle pulse on the rising edge
//              of a switch input signal
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This module is used for debounced switch input edge detection
//////////////////////////////////////////////////////////////////////////////////


module switch_pulse (
    input wire clk,           // System clock
    input wire rst,           // Synchronous reset
    input wire switch_in,     // The switch input
    output reg pulse_out      // Goes high for one clock cycle on rising edge of switch_in
);

    reg switch_prev;

    always @(posedge clk) begin
        if (rst) begin
            switch_prev <= 0;
            pulse_out   <= 0;
        end else begin
            // Detect rising edge
            if (switch_in && !switch_prev)
                pulse_out <= 1;
            else
                pulse_out <= 0;

            // Update previous state
            switch_prev <= switch_in;
        end
    end

endmodule

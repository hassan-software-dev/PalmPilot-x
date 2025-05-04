`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Habib University
// Engineer: Palmpilot X Team
// 
// Create Date: 01/05/2025 05:25:29 PM
// Design Name: Palmpilot X
// Module Name: pixel_win_gen
// Project Name: Palmpilot X
// Target Devices: Basys 3
// Tool Versions: Vivado 2020.1
// Description: Module for generating the "WIN" text display with checkered border
// 
// Dependencies: ascii_rom module
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This module generates a "WIN" text display at the center of the screen
// with a checkered border pattern around the edges
//////////////////////////////////////////////////////////////////////////////////


module pixel_win_gen(

    input clk,
    input video_on,
    input [10:0] x, y,
    output reg [11:0] time_rgb
    );
    
    localparam BORDER_SIZE = 40;
    localparam CHECKCER_SQAURE_SIZE = 20;
    
    // TEXT Digit section = 32 x 64
    localparam TEXT_X_L = 384;   // Updated left boundary (centered horizontally)
    localparam TEXT_X_R = 512;   // Updated right boundary (centered horizontally)
    localparam TEXT_Y_T = 256;   // Updated top boundary (centered vertically)
    localparam TEXT_Y_B = 320;   // Updated bottom boundary (centered vertically)

    localparam BG_X_L = 0; 
    localparam BG_X_R = 799; 
    localparam BG_Y_T = 0;
    localparam BG_Y_B = 599;
    
    // Object Status Signals
    wire TEXT_on;
    
    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;   // 3'b011 + BCD value of time component
    wire [6:0] char_addr_TEXT;
    reg [3:0] row_addr;    // row address of digit
    wire [3:0] row_addr_TEXT;
    reg [2:0] bit_addr;    // column address of rom data
    wire [2:0] bit_addr_TEXT;
    wire [7:0] digit_word;  // data from rom
    wire digit_bit;
    
    assign char_addr_TEXT = 
        (x >= 384 && x < 416) ? 7'h57 :   // 'W'
        (x >= 416 && x < 448) ? 7'h49 :   // 'I'
        (x >= 448 && x < 480) ? 7'h4E :   // 'N'
        (x >= 480 && x < 512) ? 7'h21 :   // '!'
                                7'h20;    // Default: space

    assign row_addr_TEXT = y[5:2];   // scaling to 32x64
    assign bit_addr_TEXT = x[4:2];   // scaling to 32x64
    
    // Instantiate digit rom
    ascii_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
    assign TEXT_on = (TEXT_X_L <= x) && (x <= TEXT_X_R) &&
                     (TEXT_Y_T <= y) && (y <= TEXT_Y_B);
                    
    assign BG_on = (BG_X_L <= x) && (x <= BG_X_R) &&
                   (BG_Y_T <= y) && (y <= BG_Y_B);             
        
    // Mux for ROM Addresses and RGB    
    always @* begin
        time_rgb = 12'hFFF;             // white background
        if(TEXT_on) begin
            char_addr = char_addr_TEXT;
            row_addr = row_addr_TEXT;
            bit_addr = bit_addr_TEXT;
            if(digit_bit)
                time_rgb = 12'h00F;     // red
        end
          else if(BG_on) begin
            if (x < BORDER_SIZE || x > (800 - BORDER_SIZE )|| y < BORDER_SIZE || y > (600 - BORDER_SIZE))
                if (((x/CHECKCER_SQAURE_SIZE) +(y/CHECKCER_SQAURE_SIZE) )%2==0)
                    time_rgb = 12'h0F0;     // red
                else
                    time_rgb = 12'h000; 
            end  
        else begin
        time_rgb = 12'h000;         // Set black if neither condition is met
        end
    end    
    
    // ROM Interface    
    assign rom_addr = {char_addr, row_addr};
    assign digit_bit = digit_word[~bit_addr];    
                          
endmodule


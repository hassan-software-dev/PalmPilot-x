`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////
// PalmPilot X Project - Habib University
// Created on 4/30/2025
//
// Purpose: Generate countdown display for VGA output
///////////////////////////////////////////////////////////////////////

module pixel_countdown_gen(
    input clk,
    input video_on,
    input [10:0] x, y,
    input [3:0] sec_1s,
    output reg [11:0] time_rgb
    );
    
    localparam CHECKCER_SQAURE_SIZE = 80;

    
    // TEXT Digit section = 32 x 64
    localparam TEXT_X_L = 224;
    localparam TEXT_X_R = 543; 
    localparam TEXT_Y_T = 192;
    localparam TEXT_Y_B = 256;
    
    
    // BG
    localparam BG_X_L = 0; 
    localparam BG_X_R = 799; 
    localparam BG_Y_T = 0;
    localparam BG_Y_B = 599;
    
    // Seconds 1s Digit section = 32 x 64
    localparam S1_X_L = 384;
    localparam S1_X_R = 415; 
    localparam S1_Y_T = 256;
    localparam S1_Y_B = 320;

    
    // Object Status Signals
    wire S1_on,TEXT_on,BG_on;
    
    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;   // 3'b011 + BCD value of time component
    wire [6:0] char_addr_s1,char_addr_TEXT;
    reg [3:0] row_addr;    // row address of digit
    wire [3:0] row_addr_s1,row_addr_TEXT;
    reg [2:0] bit_addr;    // column address of rom data
    wire [2:0] bit_addr_s1,bit_addr_TEXT;
    wire [7:0] digit_word;  // data from rom
    wire digit_bit; 

    
    
    assign char_addr_s1 = {3'b011, sec_1s};
    assign row_addr_s1 = y[5:2];   // scaling to 32x64
    assign bit_addr_s1 = x[4:2];   // scaling to 32x64
    
    assign char_addr_TEXT = 
    (x >= 224 && x < 256) ? 7'h47 :   // 'G'
    (x >= 256 && x < 288) ? 7'h45 :   // 'E'
    (x >= 288 && x < 320) ? 7'h54 :   // 'T'
    (x >= 320 && x < 352) ? 7'h20 :   // Space
    (x >= 352 && x < 384) ? 7'h52 :   // 'R'
    (x >= 384 && x < 416) ? 7'h45 :   // 'E'
    (x >= 416 && x < 448) ? 7'h41 :   // 'A'
    (x >= 448 && x < 480) ? 7'h44 :   // 'D'
    (x >= 480 && x < 512) ? 7'h59 :   // 'Y'
                            7'h21;    // Default: '!'


    assign row_addr_TEXT = y[5:2];   // scaling to 32x64
    assign bit_addr_TEXT = x[4:2];   // scaling to 32x64
    
    // Instantiate digit rom
    ascii_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
    assign S1_on =  (S1_X_L <= x) && (x <= S1_X_R) &&
                    (S1_Y_T <= y) && (y <= S1_Y_B);
    assign TEXT_on =  (TEXT_X_L <= x) && (x <= TEXT_X_R) &&
                    (TEXT_Y_T <= y) && (y <= TEXT_Y_B);
    assign BG_on =  (BG_X_L <= x) && (x <= BG_X_R) &&
                    (BG_Y_T <= y) && (y <= BG_Y_B);                
                
        
    // Mux for ROM Addresses and RGB    
    always @* begin
        time_rgb = 12'h00F;             // black background
        if(TEXT_on) begin
            char_addr = char_addr_TEXT;
            row_addr = row_addr_TEXT;
            bit_addr = bit_addr_TEXT;
            if(digit_bit)
                time_rgb = 12'hFFF;     // red
        end  
        else if(S1_on) begin
            char_addr = char_addr_s1;
            row_addr = row_addr_s1;
            bit_addr = bit_addr_s1;
            if(digit_bit)
                time_rgb = 12'hFFF;     // red
        end
        else if(BG_on) begin
            if (((x/CHECKCER_SQAURE_SIZE) +(y/CHECKCER_SQAURE_SIZE) )%2==0)
            time_rgb = 12'h0F0;     // red
            else
            time_rgb = 12'h000; 
        end
        else
            time_rgb = 12'h000;     // red

         
    end    
    
    // ROM Interface    
    assign rom_addr = {char_addr, row_addr};
    assign digit_bit = digit_word[~bit_addr];    
                          
endmodule
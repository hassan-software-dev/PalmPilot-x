`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Habib University
// Engineer: PalmPilot X Team
// 
// Create Date: 05/04/2025 06:20:08 PM
// Design Name: PalmPilot X
// Module Name: pixel_difficulty_gen
// Project Name: PalmPilot X Game Console
// Target Devices: Basys 3
// Tool Versions: Vivado 2020.1
// Description: Module to generate difficulty selection screen pixels
//              Handles visualization of different difficulty levels (Easy, Medium, Hard)
// 
// Dependencies: ascii_rom module for text display
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This module handles the difficulty selection interface, displaying text and
// background colors for different game difficulties
//
//////////////////////////////////////////////////////////////////////////////////


module pixel_difficulty_gen(
    input clk,
    input [1:0]selection,
    input video_on,
    input [10:0] x, y,
    output reg [11:0] time_rgb
    );
    
    localparam BORDER_SIZE = 64;
    localparam CHECKCER_SQAURE_SIZE = 32;
    
  
    localparam TE_X_L = 128; 
    localparam TE_X_R = 256; 
    localparam TE_Y_T = 64;
    localparam TE_Y_B = 128;
    
    localparam BGE_X_L = BORDER_SIZE; 
    localparam BGE_X_R = 799-BORDER_SIZE; 
    localparam BGE_Y_T = 64;
    localparam BGE_Y_B = 192;
    
    
    localparam TM_X_L = 128; 
    localparam TM_X_R = 320; 
    localparam TM_Y_T = 192;
    localparam TM_Y_B = 256;
    
    
    localparam BGM_X_L = BORDER_SIZE; 
    localparam BGM_X_R = 799-BORDER_SIZE; 
    localparam BGM_Y_T = 192;
    localparam BGM_Y_B = 320;
    
    
    localparam TH_X_L = 128; 
    localparam TH_X_R = 256;
    localparam TH_Y_T = 320;
    localparam TH_Y_B = 384;
    
    localparam BGH_X_L = BORDER_SIZE; 
    localparam BGH_X_R = 799-BORDER_SIZE; 
    localparam BGH_Y_T = 320;
    localparam BGH_Y_B = 600-BORDER_SIZE;
    
    
    localparam BG_X_L = 0; 
    localparam BG_X_R = 799; 
    localparam BG_Y_T = 0;
    localparam BG_Y_B = 599;
    
    // Object Status Signals
    wire TEXT_on;
    
    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;   // 3'b011 + BCD value of time component
    wire [6:0] char_addr_TE,char_addr_TM,char_addr_TH;
    reg [3:0] row_addr;    // row address of digit
    wire [3:0] row_addr_scl;
    reg [2:0] bit_addr;    // column address of rom data
    wire [2:0] bit_addr_scl;
    wire [7:0] digit_word;  // data from rom
    wire digit_bit;

    

assign char_addr_TE = 
    (x >= 128 && x < 160) ? 7'h45 :   // 'E'
    (x >= 160 && x < 192) ? 7'h41 :   // 'A'
    (x >= 192 && x < 224) ? 7'h53 :   // 'S'
    (x >= 224 && x < 256) ? 7'h59 :   // 'Y'
                           7'h20;     // Default: space
                           
assign char_addr_TM = 
    (x >= 128 && x < 160) ? 7'h4D :   // 'M'
    (x >= 160 && x < 192) ? 7'h45 :   // 'E'
    (x >= 192 && x < 224) ? 7'h44 :   // 'D'
    (x >= 224 && x < 256) ? 7'h49 :   // 'I'
    (x >= 256 && x < 288) ? 7'h55 :   // 'U'
    (x >= 288 && x < 320) ? 7'h4D :   // 'M'
                           7'h20;     // Default: space


assign char_addr_TH = 
    (x >= 128 && x < 160) ? 7'h48 :   // 'H'
    (x >= 160 && x < 192) ? 7'h41 :   // 'A'
    (x >= 192 && x < 224) ? 7'h52 :   // 'R'
    (x >= 224 && x < 256) ? 7'h44 :   // 'D'
                           7'h20;     // Default: space




    assign row_addr_scl = y[5:2];   // scaling to 32x64
    assign bit_addr_scl = x[4:2];   // scaling to 32x64

    
    
    
    // Instantiate digit rom
    ascii_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
     assign TE_on = (TE_X_L <= x) && (x <= TE_X_R) &&
                   (TE_Y_T <= y) && (y <= TE_Y_B);
    
    assign TM_on = (TM_X_L <= x) && (x <= TM_X_R) &&
                   (TM_Y_T <= y) && (y <= TM_Y_B);
    
    assign TH_on = (TH_X_L <= x) && (x <= TH_X_R) &&
                   (TH_Y_T <= y) && (y <= TH_Y_B);
    assign BGE_on = (BGE_X_L <= x) && (x <= BGE_X_R) &&
                    (BGE_Y_T <= y) && (y <= BGE_Y_B);
    
    assign BGM_on = (BGM_X_L <= x) && (x <= BGM_X_R) &&
                    (BGM_Y_T <= y) && (y <= BGM_Y_B);
    
    assign BGH_on = (BGH_X_L <= x) && (x <= BGH_X_R) &&
                    (BGH_Y_T <= y) && (y <= BGH_Y_B);

                    
    assign BG_on =  (BG_X_L <= x) && (x <= BG_X_R) &&
                    (BG_Y_T <= y) && (y <= BG_Y_B);             
        
    // Mux for ROM Addresses and RGB    
    always @* begin
        time_rgb = 12'hFFF;
        if(TE_on) begin
            char_addr = char_addr_TE;
            row_addr = row_addr_scl;
            bit_addr = bit_addr_scl;
            time_rgb = 12'h0F0;
            if (selection == 2'b00)
                time_rgb = 12'h00F;
            if(digit_bit)
                time_rgb = 12'hFFF;     // white
        end else if(TM_on) begin
            char_addr = char_addr_TM;
            row_addr = row_addr_scl;
            bit_addr = bit_addr_scl;
            time_rgb = 12'hFA0;
            if (selection == 2'b01)
                time_rgb = 12'h00F;
            if(digit_bit)
                time_rgb = 12'hFFF;     // white
        end else if(TH_on) begin
            char_addr = char_addr_TH;
            row_addr = row_addr_scl;
            bit_addr = bit_addr_scl;
            time_rgb = 12'hF00;
            if (selection == 2'b10)
                time_rgb = 12'h00F;
            if(digit_bit)
                time_rgb = 12'hFFF;     // white
        end else if(BGE_on) begin 
            time_rgb = 12'h0F0;
        end else if(BGM_on) begin 
            time_rgb = 12'hFA0;
        end else if(BGH_on) begin 
            time_rgb = 12'hF00;
        end else if(BG_on) begin
            if (x < BORDER_SIZE || x > (800 - BORDER_SIZE )|| y < BORDER_SIZE || y > (600 - BORDER_SIZE))
                if (((x/CHECKCER_SQAURE_SIZE) +(y/CHECKCER_SQAURE_SIZE) )%2==0)
                    time_rgb = 12'hFFF;     // red
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

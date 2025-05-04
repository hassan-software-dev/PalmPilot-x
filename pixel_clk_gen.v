`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////
// PalmPilot X Team - Habib University
// Created on 30/04/2025
//
// Purpose: Display clock values and movement text on VGA screen
//          with color-coded warnings based on minute values
///////////////////////////////////////////////////////////////////////

module  pixel_clk_gen(
    input clk,
    input video_on,
    input [6:0] movement_text,
    //input tick_1Hz,       // use signal if blinking colon(s) is desired
    input [3:0] CRITICAL_MIN,WARN_MIN,
    input [10:0] x, y,
    input [3:0] sec_1s, sec_10s,
    input [3:0] min_1s, min_10s,
    output reg [11:0] time_rgb
    );
    
    localparam BORDER_SIZE = 80;
    localparam CHECKCER_SQAURE_SIZE = 20;

    
    

        // BG
    localparam BG_X_L = 0; 
    localparam BG_X_R = 799; 
    localparam BG_Y_T = 0;
    localparam BG_Y_B = 599;
    
    //movement text
    localparam MOVE_X_L = 128;  
    localparam MOVE_X_R = 671;
    localparam MOVE_Y_T = 320;
    localparam MOVE_Y_B = 384;
    
       // Minute 10s Digit section = 32 x 64
    localparam M10_X_L = 320;
    localparam M10_X_R = 351;
    localparam M10_Y_T = 192;
    localparam M10_Y_B = 256;

    // Minute 1s Digit section = 32 x 64
    localparam M1_X_L = 352;
    localparam M1_X_R = 383;
    localparam M1_Y_T = 192;
    localparam M1_Y_B = 256;

    // Colon 2 section = 32 x 64
    localparam C2_X_L = 384;
    localparam C2_X_R = 415;
    localparam C2_Y_T = 192;
    localparam C2_Y_B = 256;

    // Second 10s Digit section = 32 x 64
    localparam S10_X_L = 416;
    localparam S10_X_R = 447;
    localparam S10_Y_T = 192;
    localparam S10_Y_B = 256;

    // Second 1s Digit section = 32 x 64
    localparam S1_X_L = 448;
    localparam S1_X_R = 479;
    localparam S1_Y_T = 192;
    localparam S1_Y_B = 256;


    
    // Object Status Signals
    wire C1_on, M10_on, M1_on, C2_on, S10_on, S1_on,BG_on;
    
    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;   // 3'b011 + BCD value of time component
    wire [6:0] char_addr_move, char_addr_m10, char_addr_m1, char_addr_s10, char_addr_s1, char_addr_c1, char_addr_c2;
    reg [3:0] row_addr;    // row address of digit
    wire [3:0]  row_addr_move,row_addr_m10, row_addr_m1, row_addr_s10, row_addr_s1, row_addr_c1, row_addr_c2;
    reg [2:0] bit_addr;    // column address of rom data
    wire [2:0]  bit_addr_move,bit_addr_m10, bit_addr_m1, bit_addr_s10, bit_addr_s1, bit_addr_c1, bit_addr_c2;
    wire [7:0] digit_word;  // data from rom
    wire digit_bit;
    
    
   
    assign char_addr_move = movement_text;
    assign row_addr_move = y[5:2];   // scaling to 32x64
    assign bit_addr_move = x[4:2];   // scaling to 32x64
    
    assign char_addr_m10 = {3'b011, min_10s};
    assign row_addr_m10 = y[5:2];   // scaling to 32x64
    assign bit_addr_m10 = x[4:2];   // scaling to 32x64
    
    
    assign char_addr_m1 = {3'b011, min_1s};
    assign row_addr_m1 = y[5:2];   // scaling to 32x64
    assign bit_addr_m1 = x[4:2];   // scaling to 32x64
    
    assign char_addr_c2 = 7'h3a;
    assign row_addr_c2 = y[5:2];    // scaling to 32x64
    assign bit_addr_c2 = x[4:2];    // scaling to 32x64
    
    assign char_addr_s10 = {3'b011, sec_10s};
    assign row_addr_s10 = y[5:2];   // scaling to 32x64
    assign bit_addr_s10 = x[4:2];   // scaling to 32x64
    
    assign char_addr_s1 = {3'b011, sec_1s};
    assign row_addr_s1 = y[5:2];   // scaling to 32x64
    assign bit_addr_s1 = x[4:2];   // scaling to 32x64
    
    // Instantiate digit rom
    ascii_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
    
    assign MOVE_on =  ( MOVE_X_L <= x) && (x <= MOVE_X_R) &&
                    (MOVE_Y_T <= y) && (y <= MOVE_Y_B);
                               
    // Minute sections assert signals
    assign M10_on = (M10_X_L <= x) && (x <= M10_X_R) &&
                    (M10_Y_T <= y) && (y <= M10_Y_B);
    assign M1_on =  (M1_X_L <= x) && (x <= M1_X_R) &&
                    (M1_Y_T <= y) && (y <= M1_Y_B);                             
    
    // Colon 2 ROM assert signals
    assign C2_on = (C2_X_L <= x) && (x <= C2_X_R) &&
                   (C2_Y_T <= y) && (y <= C2_Y_B);
                  
    // Second sections assert signals
    assign S10_on = (S10_X_L <= x) && (x <= S10_X_R) &&
                    (S10_Y_T <= y) && (y <= S10_Y_B);
    assign S1_on =  (S1_X_L <= x) && (x <= S1_X_R) &&
                    (S1_Y_T <= y) && (y <= S1_Y_B);
                    
        assign BG_on =  (BG_X_L <= x) && (x <= BG_X_R) &&
                    (BG_Y_T <= y) && (y <= BG_Y_B); 
                          
        
    // Mux for ROM Addresses and RGB    
    always @* begin
        time_rgb =  12'h0F0;             // black background
        if(MOVE_on) begin
            char_addr = char_addr_move;
            row_addr = row_addr_move;
            bit_addr = bit_addr_move;
            if(digit_bit)
                time_rgb = 12'hFFF;     // red
        end
        else if(M10_on) begin
            char_addr = char_addr_m10;
            row_addr = row_addr_m10;
            bit_addr = bit_addr_m10;
            if (min_1s==CRITICAL_MIN)
                time_rgb = 12'hF00;     // red
                else if (min_1s==WARN_MIN)
                time_rgb = 12'hFA0; 
            if(digit_bit)
                begin
                time_rgb = 12'hFFF;     // red
                end     // red
        end
        else if(M1_on) begin
            char_addr = char_addr_m1;
            row_addr = row_addr_m1;
            bit_addr = bit_addr_m1;
            if (min_1s==CRITICAL_MIN)
                time_rgb = 12'hF00;     // red
                else if (min_1s==WARN_MIN)
                time_rgb = 12'hFA0; 
            if(digit_bit)
                begin
              
                time_rgb = 12'hFFF;     // red
                end     // red
        end
        else if(C2_on) begin
            char_addr = char_addr_c2;
            row_addr = row_addr_c2;
            bit_addr = bit_addr_c2;
            if (min_1s==CRITICAL_MIN)
                time_rgb = 12'hF00;     // red
                else if (min_1s==WARN_MIN)
                time_rgb = 12'hFA0; 
            if(digit_bit)
                time_rgb = 12'hFFF;     // red
        end
        else if(S10_on) begin
            char_addr = char_addr_s10;
            row_addr = row_addr_s10;
            bit_addr = bit_addr_s10;
            if (min_1s==CRITICAL_MIN)
                time_rgb = 12'hF00;     // red
                else if (min_1s==WARN_MIN)
                time_rgb = 12'hFA0; 
            if(digit_bit)
                begin

                time_rgb = 12'hFFF;     // red
                end     // red
        end
        else if(S1_on) begin
            char_addr = char_addr_s1;
            row_addr = row_addr_s1;
            bit_addr = bit_addr_s1;
            if (min_1s==CRITICAL_MIN)
                time_rgb = 12'hF00;     // red
                else if (min_1s==WARN_MIN)
                time_rgb = 12'hFA0; 
            if(digit_bit)
                begin
                time_rgb = 12'hFFF;     // red
                end     // red
        end  
         else if(BG_on) begin
            if (x < (BORDER_SIZE/2) || x > (800 - (BORDER_SIZE/2) )|| y < (BORDER_SIZE/2) || y > (600 - (BORDER_SIZE/2)))
                begin 
                if (((x/CHECKCER_SQAURE_SIZE) +(y/CHECKCER_SQAURE_SIZE) )%2==0)
                    time_rgb = 12'hFFF;     // red
                else
                    time_rgb = 12'h000;
                end
            else if (x < BORDER_SIZE || x > (800 - BORDER_SIZE )|| y < BORDER_SIZE || y > (600 - BORDER_SIZE))
         
                if (min_1s==CRITICAL_MIN)
                    time_rgb = 12'hF00;     // red
               else if (min_1s==WARN_MIN)
                    time_rgb = 12'hFA0; 
                else time_rgb = 12'h0F0;
            else
                time_rgb = 12'h000; 
        end
        else
            time_rgb = 12'h000;
    end    
    
    // ROM Interface    
    assign rom_addr = {char_addr, row_addr};
    assign digit_bit = digit_word[~bit_addr];    
                          
endmodule
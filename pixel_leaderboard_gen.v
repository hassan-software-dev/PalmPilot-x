`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Habib University
// Engineer: PalmPilot X Team
// 
// Create Date: 04/30/2025 05:12:52 PM
// Design Name: PalmPilot X
// Module Name: pixel_leaderboard_gen
// Project Name: PalmPilot X
// Target Devices: Basys 3
// Tool Versions: Vivado 2020.1
// Description: Leaderboard generator module that displays the top 5 completion times
//              with ranking labels and formatted time values (MM:SS).
// 
// Dependencies: ascii_rom module
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This module handles the generation of the leaderboard display with proper
// formatting for time values and ranking labels.
//
//////////////////////////////////////////////////////////////////////////////////


module pixel_leaderboard_gen(
    input clk,
    input video_on,
    input [10:0] x, y,
    input [9:0] t1,t2,t3,t4,t5,
    output reg [11:0] time_rgb
    );
    
    localparam BORDER_SIZE = 40;
    localparam CHECKCER_SQAURE_SIZE = 20;

    
    // TEXT Digit section = 32 x 64
    localparam TOP5_X_L = 192;
    localparam TOP5_X_R = 351;
    localparam TOP5_Y_T = 64;
    localparam TOP5_Y_B = 128;
    
    localparam FRST_X_L = 192;
    localparam FRST_X_R = 287;
    localparam FRST_Y_T = 192;
    localparam FRST_Y_B = 256;
    
    localparam SCND_X_L = 192;
    localparam SCND_X_R = 287;
    localparam SCND_Y_T = 256;
    localparam SCND_Y_B = 320;
    
    localparam THRD_X_L = 192; // 288
    localparam THRD_X_R = 287; // 608
    localparam THRD_Y_T = 320;
    localparam THRD_Y_B = 384;
    
    localparam FRTH_X_L = 192; // 288
    localparam FRTH_X_R = 287; // 608
    localparam FRTH_Y_T = 384;
    localparam FRTH_Y_B = 448;
    
    localparam FIFT_X_L = 192; // 288
    localparam FIFT_X_R = 287; // 608
    localparam FIFT_Y_T = 448;
    localparam FIFT_Y_B = 512;
    
    localparam FRST_T_X_L = 416;
    localparam FRST_T_X_R = 575;
    localparam FRST_T_Y_T = 192;
    localparam FRST_T_Y_B = 256;
    
    localparam SCND_T_X_L = 416;
    localparam SCND_T_X_R = 575;
    localparam SCND_T_Y_T = 256;
    localparam SCND_T_Y_B = 320;
    
    localparam THRD_T_X_L = 416;
    localparam THRD_T_X_R = 575;
    localparam THRD_T_Y_T = 320;
    localparam THRD_T_Y_B = 384;
    
    localparam FRTH_T_X_L = 416;
    localparam FRTH_T_X_R = 575;
    localparam FRTH_T_Y_T = 384;
    localparam FRTH_T_Y_B = 448;
    
    localparam FIFT_T_X_L = 416;
    localparam FIFT_T_X_R = 575;
    localparam FIFT_T_Y_T = 448;
    localparam FIFT_T_Y_B = 512;


    
    localparam BG_X_L = 0; 
    localparam BG_X_R = 799; 
    localparam BG_Y_T = 0;
    localparam BG_Y_B = 599;
    
   
    // Object Status Signals
    wire TOP5_on,FRST_on,SCND_on,THRD_on,FRTH_on,FIFT_on,FRST_T_on, SCND_T_on, THRD_T_on, FRTH_T_on, FIFT_T_on;
    
   
    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;   // 3'b011 + BCD value of time component
    wire [6:0] char_addr_TOP5, 
           char_addr_FRST, char_addr_FRST_T, 
           char_addr_SCND, char_addr_SCND_T, 
           char_addr_THRD, char_addr_THRD_T, 
           char_addr_FRTH, char_addr_FRTH_T, 
           char_addr_FIFT, char_addr_FIFT_T;

    reg [3:0] row_addr;    // row address of digit
    wire [3:0] row_addr_TOP5, 
           row_addr_FRST, row_addr_FRST_T, 
           row_addr_SCND, row_addr_SCND_T, 
           row_addr_THRD, row_addr_THRD_T, 
           row_addr_FRTH, row_addr_FRTH_T, 
           row_addr_FIFT, row_addr_FIFT_T;

    reg [2:0] bit_addr;    // column address of rom data
    wire [2:0] bit_addr_TOP5, bit_addr_FRST, bit_addr_SCND, bit_addr_THRD, bit_addr_FRTH, bit_addr_FIFT, bit_addr_FRST_T, bit_addr_SCND_T, bit_addr_THRD_T, bit_addr_FRTH_T, bit_addr_FIFT_T;
    wire [7:0] digit_word;  // data from rom
    wire digit_bit;
    

    
assign char_addr_TOP5 = 
    (x >= 192 && x < 224) ? 7'h54 :   // 'T'
    (x >= 224 && x < 256) ? 7'h4F :   // 'O'
    (x >= 256 && x < 288) ? 7'h50 :   // 'P'
    (x >= 288 && x < 320) ? 7'h20 :   // ' ' (space)
    (x >= 320 && x < 352) ? 7'h35 :   // '5'
                            7'h20;    // Default: space
    assign row_addr_TOP5 = y[5:2];   // scaling to 32x64
    assign bit_addr_TOP5 = x[4:2];   // scaling to 32x64
    
    assign char_addr_FRST = 
    (x >= 192 && x < 224) ? 7'h31 :   // '1'
    (x >= 224 && x < 256) ? 7'h53 :   // 'S'
    (x >= 256 && x < 288) ? 7'h54 :   // 'T'
                            7'h20;    // space

    assign row_addr_FRST  = y[5:2];  assign bit_addr_FRST  = x[4:2];
    
    assign char_addr_SCND = 
    (x >= 192 && x < 224) ? 7'h32 :   // '2'
    (x >= 224 && x < 256) ? 7'h4E :   // 'N'
    (x >= 256 && x < 288) ? 7'h44 :   // 'D'
                            7'h20;    // space

    assign row_addr_SCND  = y[5:2];  assign bit_addr_SCND  = x[4:2];
    
    assign char_addr_THRD = 
    (x >= 192 && x < 224) ? 7'h33 :   // '3'
    (x >= 224 && x < 256) ? 7'h52 :   // 'R'
    (x >= 256 && x < 288) ? 7'h44 :   // 'D'
                            7'h20;    // space

    assign row_addr_THRD  = y[5:2];  assign bit_addr_THRD  = x[4:2];
    
    assign char_addr_FRTH = 
    (x >= 192 && x < 224) ? 7'h34 :   // '4'
    (x >= 224 && x < 256) ? 7'h54 :   // 'T'
    (x >= 256 && x < 288) ? 7'h48 :   // 'H'
                            7'h20;    // space

    assign row_addr_FRTH  = y[5:2];  assign bit_addr_FRTH  = x[4:2];
    
    assign char_addr_FIFT = 
    (x >= 192 && x < 224) ? 7'h35 :   // '5'
    (x >= 224 && x < 256) ? 7'h54 :   // 'T'
    (x >= 256 && x < 288) ? 7'h48 :   // 'H'
                            7'h20;    // space

    assign row_addr_FIFT  = y[5:2];  assign bit_addr_FIFT  = x[4:2];
    
    
    // Declare wires for each component of the time variables (minutes and seconds)
    wire [3:0] t5_min10s, t5_min1s, t5_sec10s, t5_sec1s;
    wire [3:0] t4_min10s, t4_min1s, t4_sec10s, t4_sec1s;
    wire [3:0] t3_min10s, t3_min1s, t3_sec10s, t3_sec1s;
    wire [3:0] t2_min10s, t2_min1s, t2_sec10s, t2_sec1s;
    wire [3:0] t1_min10s, t1_min1s, t1_sec10s, t1_sec1s;
    
    // Continuous assignments for the minute and second components for t5
    assign t5_min10s = t5 / 60 / 10;             // Tens place of minutes for t5
    assign t5_min1s  = (t5 / 60) % 10;           // Ones place of minutes for t5
    assign t5_sec10s = t5 % 60 / 10;             // Tens place of seconds for t5
    assign t5_sec1s  = t5 % 10;                  // Ones place of seconds for t5
    
    // Continuous assignments for the minute and second components for t4
    assign t4_min10s = t4 / 60 / 10;             // Tens place of minutes for t4
    assign t4_min1s  = (t4 / 60) % 10;           // Ones place of minutes for t4
    assign t4_sec10s = t4 % 60 / 10;             // Tens place of seconds for t4
    assign t4_sec1s  = t4 % 10;                  // Ones place of seconds for t4
    
    // Continuous assignments for the minute and second components for t3
    assign t3_min10s = t3 / 60 / 10;             // Tens place of minutes for t3
    assign t3_min1s  = (t3 / 60) % 10;           // Ones place of minutes for t3
    assign t3_sec10s = t3 % 60 / 10;             // Tens place of seconds for t3
    assign t3_sec1s  = t3 % 10;                  // Ones place of seconds for t3
    
    // Continuous assignments for the minute and second components for t2
    assign t2_min10s = t2 / 60 / 10;             // Tens place of minutes for t2
    assign t2_min1s  = (t2 / 60) % 10;           // Ones place of minutes for t2
    assign t2_sec10s = t2 % 60 / 10;             // Tens place of seconds for t2
    assign t2_sec1s  = t2 % 10;                  // Ones place of seconds for t2
    
    // Continuous assignments for the minute and second components for t1
    assign t1_min10s = t1 / 60 / 10;             // Tens place of minutes for t1
    assign t1_min1s  = (t1 / 60) % 10;           // Ones place of minutes for t1
    assign t1_sec10s = t1 % 60 / 10;             // Tens place of seconds for t1
    assign t1_sec1s  = t1 % 10;                  // Ones place of seconds for t1
    
    
   // For the first time (t1)
    // Display t1 as MM:SS or "--:--" if t1 == 0
    assign char_addr_FRST_T = 
        (t1 == 0) ? (
            (x >= 416 && x < 448) ? 7'h2D :               // '-'
            (x >= 448 && x < 480) ? 7'h2D :               // '-'
            (x >= 480 && x < 512) ? 7'h3A :               // ':'
            (x >= 512 && x < 544) ? 7'h2D :               // '-'
            (x >= 544 && x < 576) ? 7'h2D :               // '-'
                                    7'h20                 // space
        ) :
        (x >= 416 && x < 448) ? {3'b011, t1_min10s} :     // minutes tens
        (x >= 448 && x < 480) ? {3'b011, t1_min1s}  :     // minutes units
        (x >= 480 && x < 512) ? 7'h3A :                   // ':'
        (x >= 512 && x < 544) ? {3'b011, t1_sec10s} :     // seconds tens
        (x >= 544 && x < 576) ? {3'b011, t1_sec1s}  :     // seconds units
                                7'h20;                    // space
                   // space
        
    assign row_addr_FRST_T = y[5:2];  
    assign bit_addr_FRST_T = x[4:2];
    
    // For the second time (t2)
// Display t2 as MM:SS or "--:--" if t2 == 0
        assign char_addr_SCND_T = 
            (t2 == 0) ? (
                (x >= 416 && x < 448) ? 7'h2D :
                (x >= 448 && x < 480) ? 7'h2D :
                (x >= 480 && x < 512) ? 7'h3A :
                (x >= 512 && x < 544) ? 7'h2D :
                (x >= 544 && x < 576) ? 7'h2D :
                                        7'h20
            ) :
            (x >= 416 && x < 448) ? {3'b011, t2_min10s} :
            (x >= 448 && x < 480) ? {3'b011, t2_min1s}  :
            (x >= 480 && x < 512) ? 7'h3A :
            (x >= 512 && x < 544) ? {3'b011, t2_sec10s} :
            (x >= 544 && x < 576) ? {3'b011, t2_sec1s}  :
                                    7'h20;
        
            
    assign row_addr_SCND_T = y[5:2];  
    assign bit_addr_SCND_T = x[4:2];
    
   // Display t3 as MM:SS or "--:--" if t3 == 0
    assign char_addr_THRD_T = 
    (t3 == 0) ? (
        (x >= 416 && x < 448) ? 7'h2D :
        (x >= 448 && x < 480) ? 7'h2D :
        (x >= 480 && x < 512) ? 7'h3A :
        (x >= 512 && x < 544) ? 7'h2D :
        (x >= 544 && x < 576) ? 7'h2D :
                                7'h20
    ) :
    (x >= 416 && x < 448) ? {3'b011, t3_min10s} :
    (x >= 448 && x < 480) ? {3'b011, t3_min1s}  :
    (x >= 480 && x < 512) ? 7'h3A :
    (x >= 512 && x < 544) ? {3'b011, t3_sec10s} :
    (x >= 544 && x < 576) ? {3'b011, t3_sec1s}  :
                            7'h20;

    assign row_addr_THRD_T = y[5:2];  
    assign bit_addr_THRD_T = x[4:2];
    
    // For the fourth time (t4)
    // Display t4 as MM:SS or "--:--" if t4 == 0
    assign char_addr_FRTH_T = 
        (t4 == 0) ? (
            (x >= 416 && x < 448) ? 7'h2D :
            (x >= 448 && x < 480) ? 7'h2D :
            (x >= 480 && x < 512) ? 7'h3A :
            (x >= 512 && x < 544) ? 7'h2D :
            (x >= 544 && x < 576) ? 7'h2D :
                                    7'h20
        ) :
        (x >= 416 && x < 448) ? {3'b011, t4_min10s} :
        (x >= 448 && x < 480) ? {3'b011, t4_min1s}  :
        (x >= 480 && x < 512) ? 7'h3A :
        (x >= 512 && x < 544) ? {3'b011, t4_sec10s} :
        (x >= 544 && x < 576) ? {3'b011, t4_sec1s}  :
                                7'h20;

    assign row_addr_FRTH_T = y[5:2];  
    assign bit_addr_FRTH_T = x[4:2];
    
    // Display t5 as MM:SS or "--:--" if t5 == 0
    assign char_addr_FIFT_T = 
    (t5 == 0) ? (
        (x >= 416 && x < 448) ? 7'h2D :
        (x >= 448 && x < 480) ? 7'h2D :
        (x >= 480 && x < 512) ? 7'h3A :
        (x >= 512 && x < 544) ? 7'h2D :
        (x >= 544 && x < 576) ? 7'h2D :
                                7'h20
    ) :
    (x >= 416 && x < 448) ? {3'b011, t5_min10s} :
    (x >= 448 && x < 480) ? {3'b011, t5_min1s}  :
    (x >= 480 && x < 512) ? 7'h3A :
    (x >= 512 && x < 544) ? {3'b011, t5_sec10s} :
    (x >= 544 && x < 576) ? {3'b011, t5_sec1s}  :
                            7'h20;

    assign row_addr_FIFT_T = y[5:2];  
    assign bit_addr_FIFT_T = x[4:2];


    


    
    // Instantiate digit rom
    ascii_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
    assign TOP5_on =  (TOP5_X_L <= x) && (x <= TOP5_X_R) &&
                    (TOP5_Y_T <= y) && (y <= TOP5_Y_B);
                    
    assign FRST_on = (FRST_X_L <= x) && (x <= FRST_X_R) &&
                 (FRST_Y_T <= y) && (y <= FRST_Y_B);

    assign SCND_on = (SCND_X_L <= x) && (x <= SCND_X_R) &&
                     (SCND_Y_T <= y) && (y <= SCND_Y_B);
    
    assign THRD_on = (THRD_X_L <= x) && (x <= THRD_X_R) &&
                     (THRD_Y_T <= y) && (y <= THRD_Y_B);
    
    assign FRTH_on = (FRTH_X_L <= x) && (x <= FRTH_X_R) &&
                     (FRTH_Y_T <= y) && (y <= FRTH_Y_B);
    
    assign FIFT_on = (FIFT_X_L <= x) && (x <= FIFT_X_R) &&
                     (FIFT_Y_T <= y) && (y <= FIFT_Y_B);
                     
    assign FRST_T_on = (FRST_T_X_L <= x) && (x <= FRST_T_X_R) &&
                   (FRST_T_Y_T <= y) && (y <= FRST_T_Y_B);

    assign SCND_T_on = (SCND_T_X_L <= x) && (x <= SCND_T_X_R) &&
                       (SCND_T_Y_T <= y) && (y <= SCND_T_Y_B);
    
    assign THRD_T_on = (THRD_T_X_L <= x) && (x <= THRD_T_X_R) &&
                       (THRD_T_Y_T <= y) && (y <= THRD_T_Y_B);
    
    assign FRTH_T_on = (FRTH_T_X_L <= x) && (x <= FRTH_T_X_R) &&
                       (FRTH_T_Y_T <= y) && (y <= FRTH_T_Y_B);
    
    assign FIFT_T_on = (FIFT_T_X_L <= x) && (x <= FIFT_T_X_R) &&
                       (FIFT_T_Y_T <= y) && (y <= FIFT_T_Y_B);

                     
                     
    assign BG_on =  (BG_X_L <= x) && (x <= BG_X_R) &&
                    (BG_Y_T <= y) && (y <= BG_Y_B); 
                    

                
        
    // Mux for ROM Addresses and RGB    
    always @* begin
        time_rgb = 12'h000;             // blue text bg
        if(TOP5_on) begin
            char_addr = char_addr_TOP5;
            row_addr = row_addr_TOP5;
            bit_addr = bit_addr_TOP5;
            if(digit_bit)
                time_rgb = 12'hFFF;     // white
        end  else if (FRST_on) begin
            char_addr = char_addr_FRST;
            row_addr  = row_addr_FRST;
            bit_addr  = bit_addr_FRST;
            if (digit_bit)
                time_rgb = 12'hFF0;   
        end else if (SCND_on) begin
            char_addr = char_addr_SCND;
            row_addr  = row_addr_SCND;
            bit_addr  = bit_addr_SCND;
            if (digit_bit)
                time_rgb = 12'h999;
        end else if (THRD_on) begin
            char_addr = char_addr_THRD;
            row_addr  = row_addr_THRD;
            bit_addr  = bit_addr_THRD;
            if (digit_bit)
                time_rgb = 12'hA52;    
        end else if (FRTH_on) begin
            char_addr = char_addr_FRTH;
            row_addr  = row_addr_FRTH;
            bit_addr  = bit_addr_FRTH;
            if (digit_bit)
                time_rgb = 12'hFFF;    
        end else if (FIFT_on) begin
            char_addr = char_addr_FIFT;
            row_addr  = row_addr_FIFT;
            bit_addr  = bit_addr_FIFT;
            if (digit_bit)
                time_rgb = 12'hFFF;   
        end else if (FRST_T_on) begin
            char_addr = char_addr_FRST_T;
            row_addr  = row_addr_FRST_T;
            bit_addr  = bit_addr_FRST_T;
            if (digit_bit)
                time_rgb = 12'hFF0;
        end else if (SCND_T_on) begin
            char_addr = char_addr_SCND_T;
            row_addr  = row_addr_SCND_T;
            bit_addr  = bit_addr_SCND_T;
            if (digit_bit)
                time_rgb = 12'h999;
        end else if (THRD_T_on) begin
            char_addr = char_addr_THRD_T;
            row_addr  = row_addr_THRD_T;
            bit_addr  = bit_addr_THRD_T;
            if (digit_bit)
                time_rgb = 12'hA52;
        end else if (FRTH_T_on) begin
            char_addr = char_addr_FRTH_T;
            row_addr  = row_addr_FRTH_T;
            bit_addr  = bit_addr_FRTH_T;
            if (digit_bit)
                time_rgb = 12'hFFF;
        end else if (FIFT_T_on) begin
            char_addr = char_addr_FIFT_T;
            row_addr  = row_addr_FIFT_T;
            bit_addr  = bit_addr_FIFT_T;
            if (digit_bit)
                time_rgb = 12'hFFF;
        end else if (BG_on) begin
            if (x < BORDER_SIZE || x > (800 - BORDER_SIZE) || y < BORDER_SIZE || y > (600 - BORDER_SIZE))
                if (((x/CHECKCER_SQAURE_SIZE) + (y/CHECKCER_SQAURE_SIZE)) % 2 == 0)
                    time_rgb = 12'h0F0;
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

`timescale 1ns / 1ps
////////////////////////////////////////////////////////////
// Authored by PalmPilot X Team, Habib University
// Created on April 28, 2025
//
// Description: Top module for the PalmPilot X Game System
////////////////////////////////////////////////////////////


module top(
    input clk_100MHz,       // 100MHz on Basys 3
    input [3:0] ir,
    input win,
    input vga_reset,        // btnC
    input leaderboard_reset,  
    input start,
    output [3:0] car_signals,
    output hsync,           // to VGA Connector
    output vsync,           // to VGA Connector
    output [11:0] rgb       // to DAC, to VGA Connector
    );
    
    
    localparam HARD_TIME_LIMIT = 3;
    localparam HARD_REDZONE_TIME = 2;
    localparam HARD_WARN_TIME = 1;
    
    localparam MED_TIME_LIMIT = 5;
    localparam MED_REDZONE_TIME = 4;
    localparam MED_WARN_TIME = 3;
    
    localparam EASY_TIME_LIMIT = 7;
    localparam EASY_REDZONE_TIME = 6;
    localparam EASY_WARN_TIME = 5;

    localparam GET_READY_TIME = 5;
    localparam DELAY_TIME = 3; // delay time after win/lose screens before showing leaderboard
    
    reg clk_reset;
    reg [9:0] player_score;
    
    // Internal Connection Signals
    wire [10:0] w_x, w_y;
    wire video_on, p_tick;
    wire [3:0] hr_10s, hr_1s, min_10s, min_1s, sec_10s, sec_1s, count;
    reg [11:0] rgb_reg;
    wire [11:0] start_screen, play_screen, lost_screen, win_screen, leaderboard_screen, difficulty_screen;
    wire [6:0] movement_text;
    wire start_trigger;
    wire [3:0] delay;
    reg cnt_reset;
    reg delay_reset = 1'b1;
    reg score_set = 0;
    reg win_reg, lost_reg;
    wire selected;
    wire [1:0] selection;
    reg [3:0] LOST_MIN, CRITICAL_MIN, WARN_MIN;
    
    
    countdown #(.count(DELAY_TIME)) delay_cnt(
        .clk_100MHz(clk_100MHz),
        .reset(delay_reset),
        .tick_1Hz(),        // not used
        .sec_1s(delay)
    );
    
    wire reset = vga_reset | (delay == 6'd0);
    
    movement u_movement (
        .ir(ir),
        .x(w_x),
        .char_addr_TEXT(movement_text)
    );
    
    car_control cc (
        .ir(ir),
        .ctrl_signals(car_signals)
    );
    
    wire [9:0] top0, top1, top2, top3, top4;
            
    
    leaderboard_registers leaderboard_inst (
        .clk(clk_100MHz),
        .reset(leaderboard_reset),
        .new_score(player_score),
        .top_score0(top0),
        .top_score1(top1),
        .top_score2(top2),
        .top_score3(top3),
        .top_score4(top4)
    );

    
    // Instantiate Modules
    vga_controller vga(
        .clk_100MHz(clk_100MHz),
        .reset(vga_reset),
        .video_on(video_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(p_tick),
        .x(w_x),
        .y(w_y)
    );
        
    countdown #(.count(GET_READY_TIME)) cnt(
        .clk_100MHz(clk_100MHz),
        .reset(cnt_reset),
        .tick_1Hz(),        // not used
        .sec_1s(count)
    );
        

    pixel_countdown_gen pcnt(
        .clk(clk_100MHz),
        .video_on(video_on),
        .x(w_x),
        .y(w_y),
        .sec_1s(count),
        .time_rgb(start_screen)
    );
 
    new_binary_clock bin(
        .clk_100MHz(clk_100MHz),
        .reset(clk_reset),
        .tick_1Hz(),        // not used
        .sec_1s(sec_1s),
        .sec_10s(sec_10s),
        .min_1s(min_1s),
        .min_10s(min_10s),
        .hr_1s(hr_1s),
        .hr_10s(hr_10s)
    );
        
   
    // Instantiate difficulty_selector
    difficulty_selector u_difficulty_selector (
        .clk(clk_100MHz),
        .reset(reset),
        .ir(ir),
        .done(selected),
        .selection(selection)
    );
    
    pixel_clk_gen pclk (
        .clk(clk_100MHz),
        .video_on(video_on),
        .movement_text(movement_text),
        .CRITICAL_MIN(CRITICAL_MIN),
        .WARN_MIN(WARN_MIN),
        .x(w_x),
        .y(w_y),
        .sec_1s(sec_1s),
        .sec_10s(sec_10s),
        .min_1s(min_1s),
        .min_10s(min_10s),
        .time_rgb(play_screen)
    );
        
    pixel_lost_gen lost_text_unit (
        .clk(clk_100MHz),
        .video_on(video_on),
        .x(w_x),
        .y(w_y),
        .time_rgb(lost_screen)
    );
    
    pixel_win_gen win_text_unit (
        .clk(clk_100MHz),
        .video_on(video_on),
        .x(w_x),
        .y(w_y),
        .time_rgb(win_screen)
    );
    
    start_detection start_detection_inst (
        .clk(clk_100MHz),
        .btn(start),
        .reset(reset),
        .start(start_trigger)
    );

    pixel_leaderboard_gen leaderboard_display (
        .clk(clk_100MHz),
        .video_on(video_on),
        .x(w_x),
        .y(w_y),
        .t1(top0), .t2(top1), .t3(top2), .t4(top3), .t5(top4),
        .time_rgb(leaderboard_screen)
    );

    pixel_difficulty_gen difficulty_display (
        .clk(clk_100MHz),
        .selection(selection),
        .video_on(video_on),
        .x(w_x),
        .y(w_y),
        .time_rgb(difficulty_screen)
    );

    // handling difficulty
    always @(posedge clk_100MHz) begin
        if (selection == 0) begin
            LOST_MIN <= EASY_TIME_LIMIT;
            CRITICAL_MIN <= EASY_REDZONE_TIME;
            WARN_MIN <= EASY_WARN_TIME;
        end
        else if (selection == 1) begin
            LOST_MIN <= MED_TIME_LIMIT;
            CRITICAL_MIN <= MED_REDZONE_TIME;
            WARN_MIN <= MED_WARN_TIME;
        end
        else if (selection == 2) begin
            LOST_MIN <= HARD_TIME_LIMIT;
            CRITICAL_MIN <= HARD_REDZONE_TIME;
            WARN_MIN <= HARD_WARN_TIME;
        end
    end
    
    // check if lost by time
    reg lost_by_time = 0; 
    always @(posedge clk_100MHz) begin
        if(selected && min_1s == LOST_MIN) begin 
            lost_by_time <= 1; 
        end
        if (reset) begin 
            lost_by_time <= 0;  
        end
    end
        
    // set leaderboard score  
    always @(posedge clk_100MHz) begin
        if (reset) begin
            score_set <= 0;
        end 
        else if (score_set) begin
            player_score <= 0;
        end 
        else if (win && start_trigger && ~score_set) begin 
            player_score <= (((min_10s * 4'd10) + min_1s) * 6'd60) + (sec_10s * 4'd10) + sec_1s;
            score_set <= 1;
        end
    end
    
    // state logic handling
    always @(posedge clk_100MHz) begin
        if (~start_trigger) begin
            delay_reset <= 1;  // we are in leaderboard
            cnt_reset <= 1;
            clk_reset <= 1;
            win_reg <= 0;
            lost_reg <= 0;
        end else begin
            if (~selected) begin
                // do nothing
            end 
            else if(count != 6'd0) begin // our get ready screen is showing
                cnt_reset <= 0;
            end
            else if(lost_by_time) begin // we are in lost screen
                delay_reset <= 0;
                lost_reg <= 1;
                clk_reset <= 1;
            end
            else if (~win) begin // play screen
                clk_reset <= 0;  // Start countdown
            end
            else if (win) begin // we won
                delay_reset <= 0;
                win_reg <= 1;
                clk_reset <= 1;
            end
        end
    end

    // rgb buffer
    always @(posedge clk_100MHz) begin
        if(p_tick) begin
            if (~start_trigger) begin
                rgb_reg <= leaderboard_screen;
            end
            else begin
                if (~selected) 
                    rgb_reg <= difficulty_screen;
                else if (count != 6'd0) begin
                    rgb_reg <= start_screen;
                end
                else if (lost_reg) begin
                    rgb_reg <= lost_screen;
                end
                else if (~win_reg) begin
                    rgb_reg <= play_screen;
                end
                else if (win_reg) begin
                    rgb_reg <= win_screen;
                end
            end
        end
    end
    
    // output
    assign rgb = rgb_reg; 
    
endmodule
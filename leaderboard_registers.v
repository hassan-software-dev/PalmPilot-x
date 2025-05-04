`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Habib University
// Engineer: PalmPilot X Team
// 
// Create Date: 05/02/2025 12:43:54 PM
// Design Name: leaderboard_registers
// Project Name: PalmPilot X
// Target Devices: Basys 3
// Tool Versions: Vivado 2020.1
// Description: Leaderboard register module for storing and managing top game scores
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This module stores the top 5 game scores in ascending order (lower is better)
//////////////////////////////////////////////////////////////////////////////////


module leaderboard_registers (
    input clk,
    input reset,
    input [9:0] new_score,
    output reg [9:0] top_score0,
    output reg [9:0] top_score1,
    output reg [9:0] top_score2,
    output reg [9:0] top_score3,
    output reg [9:0] top_score4
);


// On reset, set leaderboard to empty (0 = no score yet)
always @(posedge clk) begin
    if (reset) begin
        top_score0 <= 10'd0;
        top_score1 <= 10'd0;
        top_score2 <= 10'd0;
        top_score3 <= 10'd0;
        top_score4 <= 10'd0;
    end
    else if (new_score != 10'd0) begin
        // Empty slot logic first (zero means unused slot)
        if (top_score0 == 10'd0) begin
            top_score0 <= new_score;
        end
        else if (top_score1 == 10'd0) begin
            if (new_score < top_score0) begin
                top_score1 <= top_score0;
                top_score0 <= new_score;
            end else begin
                top_score1 <= new_score;
            end
        end
        else if (top_score2 == 10'd0) begin
            if (new_score < top_score0) begin
                top_score2 <= top_score1;
                top_score1 <= top_score0;
                top_score0 <= new_score;
            end else if (new_score < top_score1) begin
                top_score2 <= top_score1;
                top_score1 <= new_score;
            end else begin
                top_score2 <= new_score;
            end
        end
        else if (top_score3 == 10'd0) begin
            if (new_score < top_score0) begin
                top_score3 <= top_score2;
                top_score2 <= top_score1;
                top_score1 <= top_score0;
                top_score0 <= new_score;
            end else if (new_score < top_score1) begin
                top_score3 <= top_score2;
                top_score2 <= top_score1;
                top_score1 <= new_score;
            end else if (new_score < top_score2) begin
                top_score3 <= top_score2;
                top_score2 <= new_score;
            end else begin
                top_score3 <= new_score;
            end
        end
        else if (top_score4 == 10'd0) begin
            if (new_score < top_score0) begin
                top_score4 <= top_score3;
                top_score3 <= top_score2;
                top_score2 <= top_score1;
                top_score1 <= top_score0;
                top_score0 <= new_score;
            end else if (new_score < top_score1) begin
                top_score4 <= top_score3;
                top_score3 <= top_score2;
                top_score2 <= top_score1;
                top_score1 <= new_score;
            end else if (new_score < top_score2) begin
                top_score4 <= top_score3;
                top_score3 <= top_score2;
                top_score2 <= new_score;
            end else if (new_score < top_score3) begin
                top_score4 <= top_score3;
                top_score3 <= new_score;
            end else begin
                top_score4 <= new_score;
            end
        end
        else begin
            // All slots filled: only insert if better than someone
            if (new_score < top_score0) begin
                top_score4 <= top_score3;
                top_score3 <= top_score2;
                top_score2 <= top_score1;
                top_score1 <= top_score0;
                top_score0 <= new_score;
            end
            else if (new_score < top_score1) begin
                top_score4 <= top_score3;
                top_score3 <= top_score2;
                top_score2 <= top_score1;
                top_score1 <= new_score;
            end
            else if (new_score < top_score2) begin
                top_score4 <= top_score3;
                top_score3 <= top_score2;
                top_score2 <= new_score;
            end
            else if (new_score < top_score3) begin
                top_score4 <= top_score3;
                top_score3 <= new_score;
            end
            else if (new_score < top_score4) begin
                top_score4 <= new_score;
            end
            // else: too slow to enter leaderboard
        end
    end
end

endmodule


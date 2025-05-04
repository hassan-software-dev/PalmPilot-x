# PalmPilotX FPGA Game Project

This is a Verilog-based FPGA project for a game with VGA display capabilities.

## Project Structure

The project includes:

- VGA controller and pixel generation
- ASCII ROM for text display
- Game mechanics including:
  - Countdown timer
  - Difficulty selection
  - Movement controls
  - Leaderboard functionality

## Key Components

- `ascii_rom.v`: ASCII character ROM for text display
- `car_control.v`: Game object movement control
- `countdown.v`: Game timer functionality
- `difficulty_selector.v`: Game difficulty settings
- `vga_controller.v`: VGA timing and display control
- `top.v`: Top-level module connecting all components

## Hardware Requirements

- FPGA board with VGA output
- Input controls (buttons or switches)
- Clock source (typically 100MHz)

## Build Instructions

Open the project in Xilinx Vivado, synthesize, implement, and generate the bitstream file.

## Game Instructions

[Add game instructions here]

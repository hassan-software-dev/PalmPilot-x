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

- Basys3 FPGA board
- Buttons and IR sensors (basically any input that have two discrete states or can be mapped to)
- Clock source (typically 100MHz)

## Build Instructions

Open the project in Xilinx Vivado, synthesize, implement, and generate the bitstream file.

## Some Pictures
![Leaderboard](https://github.com/user-attachments/assets/0709ceee-84a6-4373-95b9-e1d0a99ff086)
![Difficulty Selection](https://github.com/user-attachments/assets/6446b549-0e0a-4070-8e62-b0fe08710818)
![Get Ready](https://github.com/user-attachments/assets/7027bc57-997e-49cc-a9e8-be02be26c2c5)
![In Game Countdown](https://github.com/user-attachments/assets/63a5e665-5201-4897-b92a-49b7cf53af30)
![Win](https://github.com/user-attachments/assets/68d61281-cf18-41e3-91a3-36c9ec6de61a)
![Lost](https://github.com/user-attachments/assets/7c9c143e-98cd-4b7f-95be-39669ff4c43b)


This code is currently owned by me and is open to be used by anyone




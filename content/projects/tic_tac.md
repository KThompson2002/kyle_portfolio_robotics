+++
date = '2024-05-08T16:51:49-06:00'
draft = false
title = "Tic Tac Toe playing robot arm"
summary = "Robot arm which never loses tic tac toe, utilzing inverse kinematics and predetermined positions for game play and the minimax algorithm for decision making"
featured = false
thumbnail = "/img/tic-tac-toe.png"
tags = ["inverse_kinematics", "DH-Parameters", "CAD", "minimax"]
+++

## Objective:
Apply theoretical knowledge of robotics to a tangible and interactive application.

## CAD
![tic_tac_toe robot CAD](/img/tic-tac-toe.png)

## Implementation:
Completed design of a 4-degree-of-freedom (DOF) robot arm and a tic-tac-toe board with 9 designated slots for the robot or player to place game pieces.  Joints 2, 3, and 4 each uses a Dynamixel AX-12A servo for its actuation while joint 1 employs a Dynamixel AX-18A. Links consist of a mix of 3D printed parts and Dynamixel AX series frames. Inverse kinematics and DH parameters were utilized to control rotation of robot linkages. 
The mounting plate houses the 9 limit switches which are responsible for detecting the position of each piece in the game space. 
Robot arm decision making is controlled by the minimax algorithm, which will choose the move that leads to the best possible outcome (highest score), assuming the opponent, the minimizer, aims to minimize the maximizer's score.

## Primary Contributions:
Design of Tic-Tac-Toe board via Solidworks CAD and implementation of minimax algorithm via Python and Arduino IDE.

## Electronics
![ECAD](/img/tic_arduino.png)

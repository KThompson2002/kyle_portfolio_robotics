+++
title = "Ball Catching Franka Arm with YOLO"
date = '2026-01-05T11:09:08-08:00'
draft = false
summary = "Real-time ball detection using YOLO and stereo vision combined with least squares analysis trajectory prediction and the MoveIt2 libray for franka arm control."
featured = true
github = "https://github.com/KThompson2002/ball_catching_franka_arm"
thumbnail = "/img/ball.gif"
tags = ["vision", "robotics", "ROS2", "MoveIt2", "Franka_Arm", "yolo"]
+++

## Overview

This project focused on enabling a **Franka Emika Panda robot arm** to autonomously catch a thrown ball in real time. Using stereo vision and learned object detection, the system tracks a ball in flight, predicts its trajectory, and commands the robot to intercept the ball at a predefined catching plane.

The project was completed as a team-based final project for **ME 450 / ME 495**, with an emphasis on real-time perception, motion planning, and system integration in ROS 2.

**Team Members**
- Anunth Ramaswami  
- Kasina Jyothi Swaroop  
- Kyle Thompson  
- Zixin Ye  

![Tracking demo](/img/ball.gif)

---

## System Architecture

The system consists of three tightly coupled pipelines:

1. **Perception** – Ball detection and 3D localization  
2. **Prediction** – Trajectory estimation and interception point computation  
3. **Control** – Cartesian motion planning and execution using MoveIt 2  

![System Architecture](/img/Architechture.png)

---

## Perception Pipeline

- An **Intel RealSense camera** provides synchronized RGB-D data at 60 FPS.
- Multiple rosbags were recorded by throwing the ball in different trajectories and conditions.
- The collected data was labeled and used to train a YOLO object detection model using Roboflow.
- The trained model weights are loaded by the vision node at runtime.
- The **YOLO object detector** identifies the ball in the RGB stream.
- Depth data is fused with image detections to compute the ball’s **3D position**.
- Ball poses are published as ROS 2 transforms for downstream processing.

To support accurate hand–eye calibration, an **ArUco marker-based calibration pipeline** was implemented using `easy_handeye2`.

## RVIZ Display:
![RVIZ display](/img/ball_ROS.gif)

---

## Trajectory Prediction

Once the ball is detected across multiple frames:

- A trajectory prediction node estimates the ball’s flight path with a least-squared algoritm.
- The intersection point between the predicted trajectory and a predefined catching plane is computed.
- The predicted intercept pose is published in real time for motion planning.

The prediction system must balance **accuracy vs latency**, as the ball is typically in flight for only ~1 second.

---

## Robot Motion & Control

- Motion planning is handled using **MoveIt 2** with Cartesian path planning.
- The robot transitions between:
  - A ready pose  
  - A hoop pickup pose  
  - A dynamically computed catching pose  
- ROS 2 services control system state, including:
  - Picking up the catching hoop  
  - Arming the robot for a throw  
  - Resetting predictions between throws  

---

## Performance & Limitations

### Timing Constraints
- Ball flight time: ~1 second  
- Robot motion time (max scaling): ~0.56 seconds  
- Prediction requires sufficient samples before committing to a motion plan  

This narrow timing window limits the range of successful catches.

### Camera Constraints
- The RealSense depth range restricted the allowable throwing distance.
- Reduced flight time negatively impacted trajectory prediction accuracy.

---

## Improvements Explored

### Plan Caching
Motion plans were precomputed and cached to reduce planning latency.  
Testing showed planning time was already minimal (~14 ms), with execution speed remaining the primary bottleneck.

### ZED 2i Camera
A ZED 2i camera was evaluated for improved depth range and frame rate.  
Although the hardware showed promise, a custom ROS 2 wrapper resulted in dropped depth frames, leading to unreliable detections during prediction.

---

## Demo

A live demonstration showing real-time detection, trajectory prediction, and interception:

[Watch the Demo Video](https://github.com/user-attachments/assets/5c5c8cdc-81b9-49b4-8460-3c235efb2a31)

---

## My Contributions

- Designed and implemented the **trajectory prediction pipeline**
- Integrated YOLO-based perception with ROS 2 transform broadcasting
- Assisted with **MoveIt 2 Cartesian motion planning**
- Debugged RealSense depth synchronization and latency issues
- Contributed to full system integration and live testing

---

## Technologies Used

- ROS 2  
- MoveIt 2  
- Intel RealSense  
- YOLO (Ultralytics)  
- OpenCV  
- Python  
- Franka Emika Panda Robot  
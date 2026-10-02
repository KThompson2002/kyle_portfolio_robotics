+++
date = '2026-09-29T21:17:22-05:00'
draft = false
title = 'Turtlebot3 EKF SLAM from Scratch'
summary = 'A full Simultaneous Localization and Mapping (SLAM) stack for ROS 2 in C++ from scratch for Turtlebot3 Burger.'
featured = true
thumbnail = "img/slam_drive.gif"
github = "https://github.com/ME495-Navigation/slam-KThompson2002"
+++

## Overview

A fully implemented ROS 2 navigation stacks for the Turtlebot34 Burger differential drive mobile robot written in C++ from scratch. Implementation inclueds custom geometry, kinematics, lidar, simulation, and EKF SLAM libraries and nodes.

## Simulation Demo

<div class="video-container">
  <video controls preload="metadata">
    <source src="/video/Sim_Drive_example.mp4" type="video/mp4">
  </video>
</div>


# Package List

This repository consists of several ROS packages
- `nuturtle_description` - Holds the XACRO/URDF description of turtlebot and launchfiles to open them in rviz.
- `turtlelib` - Geometry and transforms library with svg visualization
- `nusim` - Sets up the simulated environment and outputs for the turtlebot simulation
- `nuturtle_control` - Nodes for controlling the turtlebot including turtle_control and odometry
- `nuturtle_control_interfaces` - Custom service and message interfaces for nuturtle_control
- `nuslam` - EKF-SLAM implementation with circle landmark detection for the turtlebot

# Turtlelib: 

This is a plain C++ core math library. Key features are:

- Angle utilities, 2d points and vectors, and rigid body transforms and twists
- An SVG renderer
- A differential- drive robot class to complete forward kinematics to convert from wheel angles to twists and future poses and inverse kinematics to convert twists to wheel velocities

# Nusim

A 2D simulator ROS 2 node to test SLAM with set noise parameters, as confirming algorithm functionality in the real world requires too many unpredictable variables. Key features are:

- Simualted encoder ticks and published joint states
- Paramters for gaussian wheel-velocity noise and randomized wheel slipping to simulate odometry drift
- Simulateds lidar scan by intesectingh rays wiht abstacles and arena walls, with parameter driven noise.
- Fake sensor output with parameter driven noise to publish to robot to tune noise levels for EKF SLAM to correct off of.

![EKF SLAM Simulation Image](/img/slam.png)


# Nuturtle Control

This package is primarily the turtle control node and odometry node.

- Turtle Control: Converts velocity commmands into motor commands and converts encoder ticks into joint states.
- Odometry: Creates dead-reckoning pose from encoder ticks, and publishes the odometry topic and TF tree for turtlebot

# NuSLAM

A package consisting of an EKF algorithm, landmark detection, and data association machine learning. 

- EKF: The filter's state holds the robot pose plus a vector of landmark positions that grows as landmarks appear. The state stacks the robot pose with every landmark position:

  $$
  \xi_t = \begin{bmatrix} \theta_t & x_t & y_t & m_{x,1} & m_{y,1} & \cdots & m_{x,N} & m_{y,N} \end{bmatrix}^T \in
  \mathbb{R}^{3+2N}
  $$
 It implements the prediction step with the motion Jacobian, including the zero-rotation case. The input is the body twist from wheel odometry, a forward displacement and a heading change. When the heading change is not
  zero, the robot moves along an arc:

  $$
  \hat{\xi}t^- = \xi{t-1} + \begin{bmatrix} \Delta\theta \ -\frac{\Delta x}{\Delta\theta}\sin\theta + \frac{\Delta
  x}{\Delta\theta}\sin(\theta+\Delta\theta) \ \frac{\Delta x}{\Delta\theta}\cos\theta - \frac{\Delta
  x}{\Delta\theta}\cos(\theta+\Delta\theta) \ 0_{2N} \end{bmatrix}
  $$

  When the heading change is zero, the robot moves in a straight line:

  $$
  \hat{\xi}t^- = \xi{t-1} + \begin{bmatrix} 0 & \Delta x\cos\theta & \Delta x\sin\theta & 0_{2N} \end{bmatrix}^T
  $$

  The state transition Jacobian is the identity plus the derivative of position with respect to heading. The covariance is then propagated:

  $$
  \Sigma_t^- = A_t,\Sigma_{t-1},A_t^T + \bar{Q}
  $$
Each detected cylinder gives a range and bearing measured in the robot frame. Let the offset from the robot to a landmark j be the following:

  $$
  \delta_x = m_{x,j} - x, \qquad \delta_y = m_{y,j} - y, \qquad d = \delta_x^2 + \delta_y^2
  $$

  The predicted measurement is:

  $$
  \hat{z}_j = h_j(\xi) = \begin{bmatrix} r_j \ \phi_j \end{bmatrix} = \begin{bmatrix} \sqrt{d} \
  \operatorname{atan2}(\delta_y, \delta_x) - \theta \end{bmatrix}
  $$


- Landmark Detection: Clusters points together by distance, and fits circles. It flters for true cylinders using the inscribed-angle atest and radius bounds to reject walls. 
- Data Association: New measurements are matched to known landmarks via Mahalonabis distance. If a measurement cannot be matched it becomes a provisional landmark until promoted after consistent sightings. $$
  \Psi_k = H_k,\Sigma,H_k^T + R, \qquad d_k = (z - \hat{z}_k)^T,\Psi_k^{-1},(z - \hat{z}_k)
  $$

  The measurement is matched to the landmark with the smallest distance, as long as it is below the threshold. The default
  threshold is 15.

# Testing

All packages include dedicated unit testing with Catch 2 for C++ libraries and catch_ros2 for ROS 2 Nodes.
After confirming functionality of various parts using unit testing, much of the implementation involves tuning various parameters to simulated and real noise, and this is where implementation on hardware becomes messy. 

## Real World Demo

Implementation on real hardware had a short deadline, and within that timeline functioning implementation was no completed. Potential improvements given more time would include reducing initial covariance values, tuning the threshold for establishing a landmark, and tuning the time before resetting provisional time. Below is a video of a testing on hardware.

<div class="video-container">
  <video controls preload="metadata">
    <source src="/video/real_sim_slam.mp4" type="video/mp4">
  </video>
</div>

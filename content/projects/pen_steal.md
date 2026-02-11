+++
date = '2026-01-03T15:41:07-08:00'
draft = false
title = 'OpenCV Pen Stealing Robot Arm'
summary = "Watch out! Utilizing OpenCV, this robot can see purple pens, identify their location, and will reach out to steal them. Keep your pens close!"
featured = true
github = "https://github.com/KThompson2002/pen-robot"
thumbnail = "/img/pen_grab.gif"
tags = ["vision", "robotics", "OpenCV"]
+++

## Overview
This project implements a **vision-guided robotic system** capable of autonomously writing and drawing with a pen. The system integrates perception, trajectory generation, and motion control within a ROS2 framework to convert visual input into precise end-effector motion.

The goal was to develop a complete perception-to-action pipeline for a structured manipulation task.

---

## System Architecture

**Perception**
- Camera-based detection of drawing workspace and target shapes
- Image processing pipeline to extract drawing paths from input images or text

**Planning**
- Conversion of image contours into ordered waypoints
- Path smoothing and scaling to match workspace constraints
- Pen up/down state management for continuous drawing

**Control**
- ROS2 nodes for trajectory execution
- Real-time communication between perception and motion modules
- End-effector control to maintain consistent contact during drawing

---

## Results

- Successfully generated smooth trajectories for writing and shape drawing
- Achieved accurate pen placement and consistent line quality
- Demonstrated reliable perception-to-motion integration within a ROS2 system

The project showcases a full robotics pipeline combining **computer vision, motion planning, and manipulation control**.

---

## Key Contributions

- Developed contour extraction and path generation from images
- Implemented ROS2-based modular architecture
- Designed trajectory execution logic with pen state control
- Integrated perception and control into a closed-loop workflow

---

## Demo
![Tracking demo](/img/pen_grab.gif)
+++
date = '2026-01-05T14:36:49-08:00'
draft = false
title = 'Jack in a Cup Impact Simulation'
summary = "Simulation of Impact Conditions when Jack is being thrown around a shaking cup, utilizing Euler Lagrage Equations, the Impact Equations, and python."
featured = true
thumbnail = "/img/JackInACup.gif"
tags = ["vision", "robotics", "ROS2", "MoveIt2", "Franka_Arm", "yolo"]
github = "https://github.com/KThompson2002/jack_cup_simulation"
+++

## Overview
This project develops a physics-based simulation of a **jack bouncing inside a rotating cup** using first-principles rigid body dynamics. The system is modeled using the **Euler–Lagrange formulation**, incorporating inertia modeling, constraint-based impact detection, and external forcing.

The goal was to create a realistic dynamic simulation capturing rotational coupling, collision effects, and energy transfer between bodies.

## Demo
![Tracking demo](/img/JackInACup.gif)

---

## System Modeling

### Inertia Modeling
- **Cup**
  - Approximated as four rectangular prisms
  - Inertia of each wall computed and combined using the **parallel axis theorem**
- **Jack**
  - Modeled as four point masses at equal distance from the center
  - Total inertia computed using the parallel axis theorem

Mass matrices were constructed for both bodies and used to compute body twists from their respective transformation matrices.

---

## Lagrangian Formulation

Generalized coordinates:

\[
q = (x_1, y_1, x_2, y_2, \theta_1, \theta_2)
\]

Steps:
1. Compute **kinetic energy** using body velocity formulation  
2. Compute **gravitational potential energy** from rotation matrices  
3. Form the **Lagrangian**

\[
L = T - V
\]

4. Apply Euler–Lagrange equations to derive system dynamics

This produced a coupled nonlinear dynamic model of the jack–cup interaction. :contentReference[oaicite:0]{index=0}

---

## Collision Detection and Constraints

Impacts were modeled using geometric constraints:

- Each cup wall \( e_1 - e_4 \)
- Each jack mass \( r_1 - r_4 \)
- **16 relative position constraints**

At each timestep:
- If displacement fell within a tolerance → **collision detected**
- Post-impact velocities computed using **elastic collision equations**

This enabled realistic bouncing behavior inside the cup. :contentReference[oaicite:1]{index=1}

---

## External Forces and Excitation

To generate sustained motion:

- Upward force applied to counteract gravity on the cup
- **Sinusoidal forcing** applied to simulate shaking
- Additional gravity compensation added for the jack
- Small initial velocity introduced to initiate impacts

These inputs produced continuous interaction without the system drifting out of frame. :contentReference[oaicite:2]{index=2}

---

## Results

The simulation successfully demonstrated:

- Coupled motion between jack and cup
- Momentum exchange during impacts
- Variable rotational behavior depending on collision geometry
- Energy transfer causing acceleration, damping, or spin reversal

The motion qualitatively resembled a physical jack bouncing inside a shaken container. :contentReference[oaicite:3]{index=3}

---

## Key Takeaways

- Implemented full **Euler–Lagrange dynamic modeling** for a multi-body system
- Developed **collision detection with constraint-based logic**
- Modeled realistic rigid-body interactions and energy transfer
- Explored stability challenges in simulation and force design

---

## Possible Improvements

- More realistic gravity treatment (currently simplified for visualization)
- Friction and damping modeling
- Contact dynamics instead of elastic impact assumption
- Removal of artificial initial velocity
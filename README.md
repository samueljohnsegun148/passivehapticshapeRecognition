# PassivehapticshapeRecognition

Passive haptic shape exploration

## Overview

This project provides code and examples for passive haptic shape recognition and exploration using a haptic device based on a pantograph mechanism. It is designed for experimenting with haptic feedback, virtual walls, and the perception of shapes (such as circles) through touch alone.

- **Main language:** Processing
- **Hardware:** Intended for use with a pantograph-style haptic device; require Haply hardware.
- **Key features:**  
  - Generation of virtual haptic walls and textures.
  - Support for rendering circular and line boundaries for tactile exploration.
  - Modular code for controlling and interfacing with the haptic system.

## Repository Structure

```
Shape_Circle/
  ├─ Circle_Shape.pde       # Main Processing sketch for passive haptic exploration
  ├─ HapticBox.pde          # Box-shaped haptic boundaries
  ├─ HapticLine.pde         # Line-shaped haptic boundaries
  ├─ Pantograph.java        # Pantograph (2DOF) mechanism kinematics & dynamics
  ├─ Pantographv3.java      # Alternate/updated Pantograph mechanism code
  ├─ sketch.properties      # Processing sketch properties
  ├─ code/
  │   └─ hAPI_V04.jar       # Java helper libraries
  └─ img/                   # (empty or for images)
LICENSE
README.md
```

## Quick Start

1. **Prerequisites**
   - [Processing](https://processing.org/) (Java mode)
   - Serial communication enabled
   - (Recommended) Haply pantograph haptic device and drivers

2. **Setup**
   - Clone this repository.
   - Open `Shape_Circle/Circle_Shape.pde` with Processing.

3. **Run**
   - Click the 'Run' button in Processing.
   - Interact with the haptic device to explore the virtual shapes.

4. **Customization**
   - Modify files such as `HapticBox.pde` and `HapticLine.pde` to explore different haptic scenarios.
   - The file `Pantograph.java` contains forward kinematics and torque calculations for the mechanism.

## Key Files

- [`Circle_Shape.pde`](Shape_Circle/Circle_Shape.pde): Main sketch for virtual wall and circle/tactile rendering.
- [`Pantograph.java`](Shape_Circle/Pantograph.java): Pantograph device simulation and control.
- [`hAPI_V04.jar`](Shape_Circle/code/hAPI_V04.jar): Java library (provided for Processing integration).
- [`LICENSE`](LICENSE): MIT License.

## References & Credits

- Code authors: Steve Ding, Colin Gallacher, Samuel Segun
- Mechanism and Processing libraries by [Haply Robotics](https://www.haply.com/) and contributors

## License

Licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

> _For any questions or setup issues, please open an issue or contact the repository owner._

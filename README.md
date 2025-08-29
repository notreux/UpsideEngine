# Upside Engine
Upside Engine It's a 2d framework that lets you create amazing games with ease. You can use it to make platformers, puzzles, shooters, and more. Upside Engine has many features to help you design your game, such as physics, animations, sounds and more. Upside Engine is the ultimate tool for 2d game development in roblox.

[Get Started](https://notreux.github.io/UpsideEngine/tutorials/get-started/Installation.html) [Documentation](https://notreux.github.io/UpsideEngine/documentation/Welcome.html)

# Roadmap
✅ Collision Masks
✅ Parallel lighting system
⬜ Angular Velocity
✅ Parallax Objects
⬜ Beams
✅ Spotlights
✅ Update outdated tests

# Changelog v3.0.0
Some things have been changed for the long term health of the project, this update brings new interesting features, such as shaders, spotlights, fluids and parallax objects. 

This update also includes a new physics implementation, which gives much more realism, it also implements a new native “circle” shape. 

### WARNING
This version won't work if you don't have [EditableImages](https://create.roblox.com/docs/es-es/reference/engine/classes/EditableImage) enabled in your game

## Breaking Changes
- Removed the movement keyword "idle" for default controllers
    - Impact: The "idle" keyword wont be automatically be played
    - Action required: Use instead one of the new idle keywords specified in the "Features" section.

- Removed the parameters in the DrawPixels() method
    - Impact: The method will be executed with default values
    - Action required: Use instead one of the new properties in LightingEnvironment listed in the "Features" section.

- Removed experimental properties from Particle
    - Impact: Using these properties will throw an error
    - Action required: Remove any usage of these properties

## Features
### New movement keywords
- "idle_left"
- "idle_right"
- "idle_up"
- "idle_down"

### Shader
- Allows you to modify the pixels of an image using EditableImages internally

### ReactiveLabel
- Allows you to create labels with animations and effects

### ProximityPrompt2D
- Allows you to create proximity prompts for your games

### Fluid
- An object that can simulate the physics of a fluid

### Parallax
- An object that can be used to create inmersive 2d backgrounds

### StaticObject
- A simpler version of PhysicalObject without physics

### Scene
- New properties
    - Gravity
    - ShaderEnvironment

### Character
- New properties
    - IsJumping

### Camera
- New properties
    - Smoothness

### LightingEnvironment
- New properties
    - LightStyle (Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
    - ChunkResolution

### Light
- Now lights use EditableImages
- New properties
    - Shape ("PointLight" or "SpotLight")
    - Rotation (only works in SpotLights)
    - Angle (only works in SpotLights)
    - Inverted (only works in PointLights)

## Particle
- New properties
    - Rotation

### PhysicalObject
- New properties
    - Shape ("Custom" or "Circle")
    - Friction
    - Acceleration

## Refactor
- Sound tracking optimization
- Character movement rework
- Physics rework

## Fixes
- SpriteList doesn't work
- Actors sometimes doesn't get initialized
- IsEqual util doesn't work correctly
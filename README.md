# Upside Engine
Upside Engine It's a 2d framework that lets you create amazing games with ease. You can use it to make platformers, puzzles, shooters, and more. Upside Engine has many features to help you design your game, such as physics, animations, sounds and more. Upside Engine is the ultimate tool for 2d game development in roblox.

[Get Started](https://thehackerpuppy.github.io/UpsideEngine/tutorials/get-started/Installation.html) [Documentation](https://thehackerpuppy.github.io/UpsideEngine/documentation/Welcome.html)

# Roadmap
✅ Collision Masks
✅ Parallel lighting system
⬜ Angular Velocity
⬜ Parallax Objects
⬜ Beams
⬜ Spotlights

# Changelog v2.0.0
Many things have been changed for the long term health of the project, the following updates will be less likely to break your code probably. It is strongly recommended to go through the tutorial again to learn the new way of working with upside engine.

## Breaking Changes
- The :Create() method has been replaced by .new(name: string)
    - Impact: Any use or reference to the :Create() method in your code will cause errors.
    - Action required: Use .new() instead, .new just accepts a parameter, the class name. It is recommended to go through the get started  tutorial again to see the new ways of doing things that were previously done automatically by passing arguments.

- The :GetService() method has been replaced by .GetService(name: string)
    - Impact: Any use of the :GetService() method using colon in your code will cause errors.
    - Action required: Use "." instead of ":".
    
- The :Extend() method has been deleted
    - Impact: Any use or reference to the :Extend() method in your code will cause errors.
    - Action required: As we have switched to idiomatic OOP this method is unnecessary..

- DrawPixels() method has changed all its parameters by the pixel size of the lights
    - Impact: Any use of the :DrawPixels() method with the old parameters in your code will cause errors.
    - Action required: DrawPixels now accepts just one parameter, the pixel size.

- Scene instance now is a folder
    - Impact: Any use or reference to the scene instance in your code will probably cause errors.
    - Action required: Now the scene and the lighting frames are grouped in a folder. When using .Instance, you access the folder, the  scene frame is named "GameFrame", and the lighting frame "Lighting".

- Removed default ScreenGui
    - Impact: The scene will not be displayed as it does not have a ScreenGui/SurfaceGui/BillboardGui as parent
    - Action required: You have to set the scene instance parent to a ScreenGui/SurfaceGui/BillboardGui.

- The "Load" and "Unload" methods of the sceneManager have been removed and replaced by the "Enable" and "Disable" scene methods
    - Impact: Any use of the "Load" and "Unload" methods in your code will cause errors.
    - Action required: You have to use the scene "Enable" and "Disable" methods instead.

## Features
- Added collision masks 
- Added parallel lighting system
- Added constant velocity to physical objects
- Added camera offset
- Added free camera (The camera follows the character when leaving from the camera limits)

## Improvements
- Lighting system rework
- Collision system rework
- Custom OOP has been deleted and all classes have been migrated to idiomatic OOP
- Physics optimization, now the physics can support more than 1000 objects in a scene
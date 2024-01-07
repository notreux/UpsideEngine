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

# Changelog v2.1.0

## Breaking changes
- The `ConstantVelocityEnabled` property has been removed
    - Impact: Any use or reference to the `ConstantVelocityEnabled` property in your code will cause errors.
    - Action required: Remove all the references to the `ConstantVelocityEnabled` property. To emulate the behaviour of this property you can set the property constantly to a specific value.

## Fixes
- Collisions wasn't working when ConstantVelocityEnabled property was enabled
- There were some files with .lua instead of .luau, which was incoherent
- HitboxScale wasn't working properly
- Jump looks forced
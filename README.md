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

### WARNING
Some Upside Engine features may not work if you don't have [EditableImages](https://create.roblox.com/docs/es-es/reference/engine/classes/EditableImage) enabled in your game

# Changelog v3.0.1

### Features  
- Added server-side physics simulation

### Refactor  
- Removed all uses of `pairs`/`ipairs` to improve consistency and performance
- Optimized the physics system with @native tag
- Enhanced error handling: errors inside event listeners now display the full traceback

### Fixes  
- Added `ClientId` validation in the replication system
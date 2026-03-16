# Upside Engine
Upside Engine It's a 2d framework that lets you create amazing games with ease. You can use it to make platformers, puzzles, shooters, and more. Upside Engine has many features to help you design your game, such as physics, animations, sounds and more. Upside Engine is the ultimate tool for 2d game development in roblox.

[Get Started](https://notreux.github.io/UpsideEngine/tutorials/get-started/Installation.html) [Documentation](https://notreux.github.io/UpsideEngine/documentation/Welcome.html)

# Roadmap
✅ Collision Masks
✅ Parallel lighting system
✅ Angular Velocity
✅ Parallax Objects
⬜ Beams
✅ Spotlights
✅ Update outdated tests

### WARNING
Some Upside Engine features may not work if you don't have [EditableImages](https://create.roblox.com/docs/es-es/reference/engine/classes/EditableImage) enabled in your game

# Changelog v3.3.0

## Summary

Physics improvements focused on correctness and per-object control. Adds gravity scaling, mass-based collision response, and fixes raycast blacklist filtering.

---

### Added

- `GravityScale` property on `PhysicalObject`. Multiplier for gravity per object (default `1`). Set to `0` to disable gravity (useful for projectiles, floating objects).

### Changed

- Collision response now distributes correction proportionally to mass. Heavier objects move less on impact, lighter objects move more. Falls back to 50/50 when both masses are zero.

### Fixed

- Raycast blacklist mode now correctly accepts arrays (`{ objectA, objectB }`) in addition to dictionaries (`{ [id] = true }`), consistent with whitelist mode.

---

# Changelog v3.2.0

## Summary

Major physics overhaul focused on performance and reliability. Introduces angular velocity, optimizes the collision pipeline, and fixes several physics behavioral issues.

**Key Features:**
- Angular velocity system with collision-generated spin and configurable properties
- Adaptive spatial hash grid for broad-phase collision optimization
- Fixed-timestep physics loop with accumulator pattern
- Improved collision response and jump reliability

---

### Added

- Angular physics properties: `AngularVelocity`, `AngularFriction`, `AngularScale`, `AngularStiffness`, `Torque`.
- `ApplyTorque()` method on `PhysicalObject`.
- Spatial hash grid for O(n) broad-phase collision detection (activates at 30+ objects).
- Continuous collision detection via velocity subdivision.
- Spring-damper stabilization system that snaps objects to stable angles when grounded.

### Changed

- Physics loop now runs at a fixed 250Hz timestep with accumulator cap to prevent death spiral on lag spikes.
- Camera and parallax trackers moved to fixed-rate loop for smoother visuals.
- Collision corrections use min/max per direction to prevent wall-squeeze flying.
- Velocity corrections clamped to never reverse direction.
- Jump uses direct velocity impulse instead of `ApplyForce` for reliability.
- GJK/EPA collision modules now use `--!native` and `--!optimize 2` for native compilation.
- Pre-allocated table buffers to reduce GC pressure.

### Fixed

- Objects flying when squeezed between walls or jumping against walls.
- Jump pausing at apex due to incorrect `IsGrounded` persistence.
- Performance regression from spatial grid table allocation (resolved with table reuse).
- Character visual judder caused by camera tracking at different rate than physics.


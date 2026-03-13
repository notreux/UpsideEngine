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

# Changelog v3.2.0

## Summary

This update focuses on runtime stability. It hardens character-related trackers during destroy/respawn flows, fixes a few core regressions caught by the test suite, and makes networking more resilient to stale request state on the server.

**Key Features:**
- Safer character and subject lifecycle handling
- Test-driven fixes for connection waits, lighting setup, and scene raycasts
- More robust server networking request cache handling

---

### Added

- Automatic cleanup hooks when tracked characters or subjects are destroyed in runtime services.
- Root-level `context7.json` support for the Upside Engine Context7 entry.

### Changed

- `CrossPlatformService`, camera subjects, and sound subjects now release destroyed references automatically.
- Runtime trackers now tolerate missing `Character`, `Subject`, or backing `Instance` values during respawn gaps.
- Lighting pixel startup no longer blocks on a nested `task.wait()` during tests.

### Removed
- No removals in this release.

### Fixed

- Fixed runtime errors from `CrossPlatformTracker`, `ProximityPromptTracker`, `ParallaxTracker`, and `SoundTracker` when characters are destroyed and respawned.
- Fixed `Connection:Wait()` timeout behavior so timed waits resume correctly and tests do not hang.
- Fixed `Scene:Raycast()` iterating over `nil` when no filter list is provided.
- Fixed server networking errors caused by stale `RequestsCache` entries and orphaned pending requests.


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

# Changelog v3.1.0

## Summary

This update introduces a comprehensive authority management system for multiplayer functionality, significantly improving the replication system and network synchronization capabilities. The new AuthorityService provides fine-grained control over which client or server has authority over specific objects, essential for preventing conflicts in multiplayer environments.

Additionally, this update includes important type definition fixes and improvements, particularly for TypeScript users, ensuring better type safety and developer experience.

**Key Features:**
- Authority management system (AuthorityService)
- Enhanced replication system with better client-server communication
- Improved type definitions with bug fixes
- Better property categorization and management
- New geometry utilities for improved raycasting

---

### Added

#### New Services
- **AuthorityService**: New service for managing authority assignments in multiplayer environments
  - Controls which client or server has authority over specific objects
  - Provides `SetAuthority()` method to assign authority to objects (Server/Client)
  - Provides `GetAuthority()` method to retrieve current authority assignments
  - Defaults to "Server" authority when not explicitly set
  - Only server can manage authority assignments

#### New Types
- **AuthorityType**: New type definition for authority management ("Server" | "Client")
  - Added to both Luau and TypeScript type definitions

#### New Utilities
- **GetCorners.luau**: New geometry utility function for calculating corners of objects
  - Added to `src/Lib/Util/Geometry/` directory

#### New Replication System
- **NetworkingService**: 
  - Now the `ReplicationRequest` event is only fired when the request comes from a client, so it should only be used on the server side
- **Handlers.luau**: New replication handlers module
  - Handles object data updates from clients
  - Processes property changes and replication

#### New Properties file
- **Properties.luau**: Replaces `EssentialProperties.luau` with expanded functionality
  - Added `NonReplicable` property category for properties that should not be replicated
  - Added `Replicable` property category for properties that can be replicated
  - Includes comprehensive property lists for all object types (StaticObject, Sprite, PhysicalObject, Instance)
  - Better organization of property metadata

### Changed

#### Scene Class Enhancements
- Enhanced `Scene:Raycast2d()` method with improved corner detection using new GetCorners utility
- Added visibility bounds calculation for raycasting
- Added circle shape support in raycasting
- Improved raycast filtering and collision detection logic
- Better handling of object dimensions and corners in raycast operations

#### NetworkingService Improvements
- Added `ServerReplication` property (boolean, defaults to true) to control server-side replication
- Added `RequestsCache` property for storing replication requests indexed by client UserId
- Improved `Cache` property documentation - now explicitly stores cached object data for change detection
- Enhanced object replication logic
- Better handling of client-server communication
- Improved data synchronization between clients

#### Networking Runtime
- Refactored remote event handling with new handler system
- Integrated new replication handlers for client requests
- Enhanced server-side object replication processing
- Improved data encoding/decoding for network transmission
- Better error handling and validation

#### Request Class
- Updated internal request handling with improved property management
- Enhanced parameter processing

#### UpsideEngine Core
- Updated to include AuthorityService in service registry
- Minor initialization improvements

### Removed
- **EssentialProperties.luau**: Replaced by the more comprehensive Properties.luau module

### Fixed

#### TypeScript Definitions
- Fixed typo: `Filterinterface` → `FilterType` in `Raycast2dParams`
- Fixed `To` property type in `Raycast2dParams` from `any` to `Vector2`
- Improved type safety for `Dictionary<K, V>` type definition
- Better type definitions for `Event` interface with proper `Record<string, unknown>` types
- Improved `BaseClass` interface with better method signatures:
  - Methods now properly return `void` instead of `any` where appropriate
  - Better parameter typing with `...args: any[]`
  - Removed unused `Extend` method from interface
- Better formatting and consistency across type definitions (commas to semicolons)

#### Luau Type Definitions
- Enhanced type exports consistency


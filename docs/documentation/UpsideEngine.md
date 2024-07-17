# Upside Engine

On this page you will find information about the object that is returned when you access the engine.
In this object you have access to all classes and services of the engine

!!! info
    This object was extended from [EventEmitter](Classes/EventEmitter.md)

<br>
# Properties

## [string](https://create.roblox.com/docs/datatypes/string) <u>Version</u>   
The current installed upside engine version

___

# Methods

## [void]() `new(ClassName: string)` 
This method creates any of these classes:

- [Scene](autogen/Scene.md)
- [Environment](autogen/Environment.md)
- [Character](autogen/Character.md)
- [Sprite](autogen/Sprite.md)
- [Particle](autogen/Particle.md)
- [Shader](autogen/Shader.md)
- [StaticObject](autogen/StaticObject.md)
- [PhysicalObject](autogen/PhysicalObject.md)
- [Sound](autogen/Sound.md)
- [Light](autogen/Light.md)

___

## [void]() `GetService(ServiceName: string)` 
This method returns any of these services:

- [SceneManager](autogen/SceneManager.md)
- [NetworkingService](autogen/NetworkingService.md)
- [CrossPlatformService](autogen/CrossPlatformService.md)
- [PluginSupportService](autogen/PluginSupportService.md)

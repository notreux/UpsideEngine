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

## [void]() `Create(ClassName: string, ...any)` 
This method creates any of these classes:

` Scene, Environment, Character, Sprite, Particle, PhysicalObject, Sound, Light `

___

## [void]() `Extend(ClassName: string, ClassData: ClassData)` 
This method extends any of these classes:

` Scene, Environment, Character, Sprite, Particle, PhysicalObject, Sound, Light `

___

## [void]() `GetService(ServiceName: string)` 
This method returns any of these services:

` SceneManager, NetworkingService, CrossPlatformService, PluginSupportService `

___

## [void]() `Optimizate(Options: dictionary)` 
Removes innecesary roblox scripts

???+ info
    ```lua
    UpsideEngine:Optimizate({
        TimeOut = 1, -- The maximum yield time for waiting every roblox script
        DeleteChat = true
    })
    ```

# BaseClass
All objects are based on this class

<br>
# Properties

##  [readonly]() [string](https://create.roblox.com/docs/reference/engine/libraries/string) <u>ClassName</u>
The name of the class

___

## [readonly]()  [string](https://create.roblox.com/docs/reference/engine/libraries/string) <u>Name</u>
The name of the object

___

## [string](https://create.roblox.com/docs/reference/engine/libraries/string) <u>Id</u>
A unique identifier for each object


# Methods

## [BaseClass]() `new()` 
Creates a new object
???+ example
    ```lua
    BaseClass.new()
    ```

## [boolean](https://create.roblox.com/docs/scripting/luau/nil) `IsA(className: string)` 
IsA returns true if the Instance's class is equivalent to or a subclass of a given class name

___

## [void](https://create.roblox.com/docs/scripting/luau/nil) `SetName(name: string)` 
Sets the object name


___

## [void](https://create.roblox.com/docs/scripting/luau/nil) `Destroy()` 
Destroys the object

# Events

## Destroy

| Parameters | DataType |
| ---------- | -------- |
| Property   | String   |
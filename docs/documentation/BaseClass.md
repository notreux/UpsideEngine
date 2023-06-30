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
    BaseClass:new()
    ```

___

## [BaseClass?]() `Extend(ClassName: string, ClassStructure: dictionary)` 
Creates a new class

???+ example
    ```lua
    local methods = {}
    local constructor = {}

    function constructor:Puppy(breed: string)
        addReadonly({ breed = breed }) --[[ 
            This method is useful to add read-only properties 
            that cannot be added when a class is extended 
        ]]
    end

    function methods:Bark()
        print("Woof!!")
    end

    Class:Extend("Puppy", {
        constructors = constructor,
        methods = methods,

        private = { -- Only can be read or changed by the class methods
            Tired = true
        },

        readonly = { -- Can't be changed without access to restricted data
            Happy = true
        },

        rules = { -- Can be changed using the same type
            Lazy = true,
            Location = Vector2.zero,
        }
    })
    ```
___

## [boolean](https://create.roblox.com/docs/scripting/luau/nil) `IsA(className: string)` 
IsA returns true if the Instance's class is equivalent to or a subclass of a given class name

___

## [void](https://create.roblox.com/docs/scripting/luau/nil) `SetName(name: string)` 
Sets the object name


___

## [void](https://create.roblox.com/docs/scripting/luau/nil) `Destroy()` 
Destroys the object

# Events

## Changed

| Parameters | DataType |
| ---------- | -------- |
| Property   | String   |

## Destroy

| Parameters | DataType |
| ---------- | -------- |
| Property   | String   |
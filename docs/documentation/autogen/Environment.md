# [Extended from BaseObject](BaseObject.md) Environment 
This class is used to storage objects and interact with them in an easier way
	 
# Properties

## [table](table.md) Content 
 
```lua
{ 	}
```
## [number](number.md) Count
The amount of objects in this environment



# Methods

## [Environment](Environment.md) Constructor(`instanceType: string?`) 
 
## [any](any.link) Get(`index: string`) 
 Gets the object with the specified index
	
## [void](any.link) SetOne(`value: any, index: string`) 
 Adds an object with the specified index, if no parameter is specified it will use the next number of the count property as index
	
## [void](any.link) AddOne(`value: any, index: string`) 
 Adds an object with the specified index, if no parameter is specified it will use the next number of the count property as index
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) RemoveOne(`index: string`) 
 Removes the object with the specified index
	
## [boolean](https://create.roblox.com/docs/scripting/luau/booleans) HasOne(`index: string`) 
 Checks if the environment has a value with the specified index
	
## [(boolean, Dictionary<string, boolean>)](https://create.roblox.com/docs/scripting/luau/booleans) Has(`objects: Array<string>`)	
```lua	
local hasAll, dictionary = treeEnv:Has({		
	"Tree1",
	"Tree2",
	"Tree4"	
	})	

print(hasAll, dictionary) 
-- output: false, { Tree1 = true, Tree2 = true, Tree4 = false }	
``` 
 Checks if the environment contains every specified index and returns a boolean and a dictionary with boolean values, example:
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Add(`objects: Dictionary<string, any>`) 
 Adds objects with the specified index
	```lua
	treeEnv:Add({
		"Tree1" = tree.new(),
		"Tree2" = tree.new(),
		"Tree3" = tree.new()
	})

	print(treeEnv:Get("Tree2")) -- output: Tree2
	```
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Remove(`objects: Array<string>`) 
 Removes the objects with the specified index, example:
	```lua
	treeEnv:Remove({ "Tree1", "Tree2", "Tree3" })
	print(treeEnv:Get("Tree2")) -- output: nil
	```
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Update(`objects: Dictionary<string, any>`) 
 Updates the objects with the specified index, example:
```lua
treeEnv:Update({
	Tree1 = treeEnv:Get("Tree2"),
	Tree2 = treeEnv:Get("Tree1"),
})
```
	
## [any](any.link) FindByName(`name: string`) 
 Finds an object by his name
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetProperty(`property: string, value: any`) 
 Sets the specified property in every object in the environment
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Run(`method: string, ...any`) 
 Executes the specified methods in every object in the environment with the specified parameters
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




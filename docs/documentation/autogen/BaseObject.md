# BaseObject
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class is the base class of the majority of classes
	 
 
# Properties

## [readonly](readonly.md) [Instance](Instance.md) <u>Instance</u> 
The object instance
		
___
## [readonly](readonly.md) [string](string.md) <u>Scene</u> 
The object scene ID
		
___
## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 
The class name of the object instance
		
___
## [readonly](readonly.md) [table](table.md) <u>Tags</u> 
This table stores all the tags of the object
 
???+ Content 
	```lua 
	{ 	} 
	```


# Methods

### [BaseObject](BaseObject.md) Constructor`(parent: Scene)` 

___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Set`(properties: Dictionary<string, any>)` 
Sets the properties of the object instance
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) AddTag`(tag: string)` 
Adds a tag to the object
	
___
### [boolean](https://create.roblox.com/docs/scripting/luau/booleans) HasTag`(tag: string)` 
Checks if the object contain the specified tag
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) RemoveTag`(tag: string)` 
Removes a tag from the object
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




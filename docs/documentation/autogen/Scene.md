# Scene
!!! info 
	 This object was [Extended from BaseObject](BaseObject.md)
This class is useful to have a workspace and manage your project more easily
	 
 
# Properties

## [readonly](readonly.md) [table](table.md) <u>Objects</u> 
This table stores all the objects in the scene
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 

___
## [readonly](readonly.md) [SoundEnvironment](SoundEnvironment.md) <u>SoundEnvironment</u> 
This is the SoundEnvironment of the scene
		
___
## [readonly](readonly.md) [ParticleEnvironment](ParticleEnvironment.md) <u>ParticleEnvironment</u> 
This is the ParticleEnvironment of the scene
		
___
## [readonly](readonly.md) [LightingEnvironment](LightingEnvironment.md) <u>LightingEnvironment</u> 
This is the LightingEnvironment of the scene

___


# Methods

### [Scene](Scene.md) Constructor`(parent: Instance)` 

___
### [void](https://create.roblox.com/docs/scripting/luau/nil) AddObject`(object: BaseObject)` 
Adds the specified object
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) RemoveObject`(object: BaseObject)` 
Removes the specified object
	
___
### [BaseObject?](BaseObject.md) FindByName`(name: string)` 
Finds an object by his name
	
___
### [boolean](https://create.roblox.com/docs/scripting/luau/booleans) HasObject`(object: BaseObject)` 
Checks if the object is in the scene
	
___
### [Array<string>](https://create.roblox.com/docs/scripting/luau/tables#arrays) GetTaggedObjects`(tag: string)` 
Gets all the objects with the provided tags in the scene
	
___
### [Raycast2dResult](/documentation/datatypes/Raycast2DResult.html) Raycast`(info: Raycast2dParams)` 
Casts a ray using the Raycast2dParams. If it finds an elegible object a Raycast2dResult is returned containing the results of the operations
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




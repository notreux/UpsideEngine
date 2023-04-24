# SceneManager
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class save and build the engine data
	 
 
# Properties

## [readonly](readonly.md) [table](table.md) <u>Scenes</u> 
 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [table](table.md) <u>ActiveScenes</u> 
This dictionary stores all the active scenes
	 
???+ Content 
	```lua 
	{ 	} 
	```


# Methods

### [void](https://create.roblox.com/docs/scripting/luau/nil) Load`(scene: Scene)` 
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Unload`(scene: Scene)` 
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
___
### [Scene?](https://create.roblox.com/docs/scripting/luau/nil) FindByName`(name: string)` 
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
___
### [Scene](https://create.roblox.com/docs/scripting/luau/nil) Get`(Id: string)` 
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|SceneLoaded|Params -> [Scene](Scene.md) <br>Fired when a scene is loaded<br>|
|SceneUnloaded|Params -> [Scene](Scene.md) <br>Fired when a scene is unloaded<br>|




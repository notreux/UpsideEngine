# [Extended from EventEmitter](EventEmitter.md) SceneManager 
This class save and build the engine data
	 
# Properties

## [table](table.md) Scenes 
 
```lua
{ }
```
## [table](table.md) ActiveScenes 
This dictionary stores all the active scenes
	 
```lua
{ }
```


# Methods
## [Scene?](https://create.roblox.com/docs/scripting/luau/nil) FindByName(`name: string`) 
 Finds a scene by the name
	
## [Scene](Scene.md) Get(`Id: string`) 
 Returns the scene with the specified Id
	


# Events
|<div style="width:100%; max-size: 100%">Name</div>|<div style="width:100%; max-size: 100%">Description</div>|
|---|---|
|SceneLoaded|Params -> [Scene](Scene.md) <br>  Fired when a scene is loaded<br>  |
|SceneUnloaded|Params -> [Scene](Scene.md) <br>  Fired when a scene is unloaded<br>|




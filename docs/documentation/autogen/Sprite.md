# Sprite
!!! info 
	 This object was [Extended from PhysicalObject](PhysicalObject.md)
This class is used to play sounds
	 
 
# Properties

## [readonly](readonly.md) [boolean](boolean.md) <u>IsPlaying</u> 
Indicates if the sprite is playing
		
___
## [readonly](readonly.md) [table](table.md) <u>Active</u> 
This table stores information about the active spritesheet
 
???+ Content 
	```lua 
	{
 		Name: string,
		CurrentFrame: Vector2,
		SecondsPerFrame: number,
		NextStepReady: boolean,
	} 
	```
## [rules](rules.md) [number](number.md) <u>SecondsPerFrame</u> 
This is the time to wait between frame and frame
		
___
## [rules](rules.md) [table](table.md) <u>Sprites</u> 
This table stores all sprite sheets and sprite lists 
		 
???+ Content 
	```lua 
	{ 	} 
	```


# Methods

### [Sprite](Sprite.md) Constructor`(parent: Scene, size: Vector2)` 
The second parameter is the size of a cell of every frame of an sprite sheet, this can be changed using the .ImageRectSize property of the object Instance 
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetSpriteSheet`(name: string, url: string, frames: Vector2)` 
Adds a new sprite sheet to the object, the sprite will be played using as reference the amount of cells in the X axe and the Y axe, this must be provided in the third paramether as a Vector2
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetSpriteList`(name: string, list: Array<string>)` 
Adds a new sprite list to the object, it will play the animation using the order in the provided list, this list must contain the urls of every frame
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Play`(name: string, secondsPerFrame: number?)` 
Plays the specified sprite if exists, if secondsEveryFrame is specified it will be used instead of .SecondsPerFrame
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Stop`()` 
Stops the reproduction of the current playing sprite sheet or sprite list
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




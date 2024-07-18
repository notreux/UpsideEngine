# [Extended from PhysicalObject](PhysicalObject.md) Sprite 
This class is used to play sounds
	 
# Properties

## [boolean](boolean.md) IsPlaying
Indicates if the sprite is playing
  
## [number](number.md) SecondsPerFrame
This is the time to wait between frame and frame
  
## [table](table.md) Sprites 
This table stores all sprite sheets and sprite lists 
   
```lua
{ }
```
## [table](table.md) Active 
This table stores information about the active spritesheet
 
```lua
{
 	Name: string,
	CurrentFrame: Vector2,
	SecondsPerFrame: number,
	NextStepReady: boolean,
}
```


# Methods

## [void](https://create.roblox.com/docs/scripting/luau/nil) SetSpriteSheet(`name: string, url: string, frames: Vector2`) 
 Adds a new sprite sheet to the object, the sprite will be played using as reference the amount of cells in the X axe and the Y axe, this must be provided in the third paramether as a Vector2
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetSpriteList(`name: string, list: Array<string>`) 
 Adds a new sprite list to the object, it will play the animation using the order in the provided list, this list must contain the urls of every frame
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Play(`name: string, secondsPerFrame: number?`) 
 Plays the specified sprite if exists, if secondsEveryFrame is specified it will be used instead of .SecondsPerFrame
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Stop() 
 Stops the reproduction of the current playing sprite sheet or sprite list
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




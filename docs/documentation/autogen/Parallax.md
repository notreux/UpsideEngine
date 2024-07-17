# [Extended from BaseObject](BaseObject.md) Parallax 
This class is used to create inmersive backgrounds
	 
# Properties

## [Vector2](Vector2.md) CanvasSize
Defines the image zoom, if the value is 1X, 1Y it will see the whole image as expected, if you set it to 2X, 2Y you only will be able see half of the image
		
## [Vector2](Vector2.md) Offset
Defines the scroll position of the parallax object
		
## [boolean](boolean.md) Track
Defines if Update method should be called automatically
		
## [boolean](boolean.md) LockToCamera
Locks the Parallax object to the camera position

## [Vector2](Vector2.md) AnchorPoint



# Methods

## [void](https://create.roblox.com/docs/scripting/luau/nil) SetTexture(`texture: string`) 
 Sets the tile texture
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) UpdateTiles() 
 Updates the parallax properties (position, canvasSize, etc.), its automatically called when Track is enabled
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




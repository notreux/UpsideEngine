# [Extended from Environment](Environment.md) LightingEnvironment 
This class is one of the most important components of a scene, is used to manage everything related with the light 
	 
# Properties

## [Color3](Color3.md) AmbientColor
This is the color of every pixel of the ambient, we can say is the darkness color
		
## [number](number.md) AmbientTransparency
This is the transparency of the ambient, we can say is the darkness transparency
		
## [number](number.md) UpdateFrequency
This is the seconds between every update of the pixels in the screen
		
## [number](number.md) LightIntensity
This is the intensity for all the lights in the scene



# Methods

## [LightingEnvironment](LightingEnvironment.md) Constructor(scene: Scene) 
 
## [void](https://create.roblox.com/docs/scripting/luau/nil) DrawPixels(pixelSize: number) 
 Draws the pixels for the scene with the specified pixel size
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) UpdateScreen() 
 Updates the position, the transparency and the color of the ambient
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




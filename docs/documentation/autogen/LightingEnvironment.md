# LightingEnvironment
!!! info 
	 This object was [Extended from Environment](Environment.md)
This class is one of the most important components of a scene, is used to manage everything related with the light 
	 
 
# Properties

## [rules](rules.md) [Color3](Color3.md) <u>AmbientColor</u> 
This is the color of every pixel of the ambient, we can say is the darkness color
		
___
## [rules](rules.md) [number](number.md) <u>AmbientTransparency</u> 
This is the transparency of the ambient, we can say is the darkness transparency
		
___
## [rules](rules.md) [number](number.md) <u>UpdateFrequency</u> 
This is the seconds between every update of the pixels in the screen
		
___
## [rules](rules.md) [number](number.md) <u>PixelIndex</u> 
This is the pixel in the middle of every large pixel, used for internal purposes
		
___
## [rules](rules.md) [number](number.md) <u>Distance</u> 
This is the distance between every large pixel, used for internal purposes

___
## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 

___
## [readonly](readonly.md) [table](table.md) <u>Pixels</u> 
Stores all the ambient pixels
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [number](number.md) <u>LightingIntensity</u> 

___


# Methods

### [LightingEnvironment](LightingEnvironment.md) Constructor`(parent: Frame)` 

___
### [void](https://create.roblox.com/docs/scripting/luau/nil) DrawPixels`(settings: any)` 
Draws the pixels for the scene with the specified settings
	```lua
		settings = {
			Pixels = 800, -- We can say that is the resolution for the ambient, is limited to 2000
			Resolution = Vector2.new(1080, 1920) -- Defines the resolution to take as reference, is going to use the screen resolution if none is specified
			AutoScale = true -- Defines if the amount of pixels is going to be scaled depending on the resolution
		}
	```
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetLightingIntensity`(value: number)` 
Sets the base intensity for all the lights in the scene
	
___
### [void](https://create.roblox.com/docs/scripting/luau/numbers) GetLightingIntensity`()` 
Gets the base intensity for all the lights in the scene 
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) UpdateScreen`()` 
Updates the position, the transparency and the color of the ambient
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




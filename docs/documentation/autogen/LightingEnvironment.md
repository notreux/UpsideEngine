C:/Users/Reux/Documents/Develop/ue/UpsideEngine/docs/header.md# [Extended from Environment](Environment.md) LightingEnvironment 
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
  
## [Enum](Enum.md) LightStyle
Determines the light rendering mode, there are two modes Enum.ResamplerMode.Pixelated and Enum.ResamplerMode.Default, the default value is Enum.ResamplerMode.Pixelated
  
## [number](number.md) ChunkColumns
Determines the number of columns for the chunks, the number of rows is calculated automatically, the default value is 1

## [Vector2](Vector2.md) ChunkResolution
Determines the resolution for every chunk of the screen
  


# Methods
## [void](https://create.roblox.com/docs/scripting/luau/nil) DrawPixels() 
 Draws the pixels for the scene with the specified resolution
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) UpdateScreen() 
 Updates the position, the transparency and the color of the ambient
	


# Events
There is no events for this class



# [Extended from BaseObject](BaseObject.md) StaticObject 
This class is used to create a basic object, without physics or animations
	 
# Properties

## [Vector2](Vector2.md) ChromaticAberrationPoint
This is the point which is being used as reference for the chromatic aberration
  
## [table](table.md) ChromaticAberration 
The instances which makes the chromatic aberration effect
   
```lua
{ }
```
## [Shader](Shader.md) Shader
Is the shader of the object

## [number](number.md) ChromaticAberrationIntensity

## [number](number.md) ChromaticAberrationDistance

## [boolean](boolean.md) ChromaticAberrationConnection



# Methods
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetShader(`shader: Shader`) 
 Sets the shader for this object
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Load(`url: string`) 
 Loads an image for the current object and is set as the instance image
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetChromaticAberration(`Intensity: number, Distance: number, Point: Vector2`) 
 Sets chromatic aberration for the image using a center as reference, by default the center is the middle of the screen, 
 to disable the chromatic aberration send 0 as first parameter
 


# Events
There is no events for this class



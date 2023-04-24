# Particle
!!! info 
	 This object was [Extended from BaseObject](BaseObject.md)
!!! warning 
		Currently it's recommended to use sprites to make particles/vfx, this class is in experimental state and can change a lot

		_____
		This class is used for vfx

	 
 
# Properties

## [readonly](readonly.md) [Vector2](Vector2.md) <u>Angle</u> 
Depending on the value the particles will be more dispersed
		
___
## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 

___
## [readonly](readonly.md) [Character](Character.md) <u>Subject</u> 
The subject which is going to be the center of emission of the particle, a character, sprite, etc...
		
___
## [readonly](readonly.md) [number](number.md) <u>MaxRate</u> 
Is the maximum amount of particles that can exist at the same time
		
___
## [readonly](readonly.md) [number](number.md) <u>Units</u> 
Is the amount of particles that are existing at this moment
		
___
## [rules](rules.md) [table](table.md) <u>Properties</u> 
Is a table with the initial properties of the particle which is going to be generated
		 
???+ Content 
	```lua 
	{
 		Image: string,
	} 
	```
## [rules](rules.md) [table](table.md) <u>Goals</u> 
Is a table with the goals of the particles
		 
???+ Content 
	```lua 
	{
 		Size: UDim2,
		ImageTransparency: number,
	} 
	```
## [rules](rules.md) [TweenInfo](TweenInfo.md) <u>Info</u> 
Is the tween info of the tween which is going to be used to move the particles
		
___
## [rules](rules.md) [boolean](boolean.md) <u>TrackLight</u> 
!!! warning 
			Experimental, dont use
		
___
## [rules](rules.md) [boolean](boolean.md) <u>CanCollide</u> 
!!! warning 
			Experimental, dont use
		
___
## [rules](rules.md) [boolean](boolean.md) <u>Enabled</u> 
When its enabled new particles can be emitted
		
___
## [rules](rules.md) [number](number.md) <u>LightBrightness</u> 
!!! warning 
			Experimental, dont use
		
___
## [rules](rules.md) [number](number.md) <u>LightRange</u> 
!!! warning 
			Experimental, dont use

___
## [rules](rules.md) [number](number.md) <u>Range</u> 
Is the distance that can be traveled by each particle 
		
___
## [rules](rules.md) [number](number.md) <u>LifeTime</u> 
The number of seconds the particle will be active before being destroyed
		
___
## [rules](rules.md) [number](number.md) <u>Clock</u> 
Used for internal purposes
		
___
## [rules](rules.md) [number](number.md) <u>Rate</u> 
Is the amount of particles which is going to be generated
		
___


# Methods

### [void](https://create.roblox.com/docs/scripting/luau/nil) SetSubject`(subject: Character)` 
Sets the subject property
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetAngle`(Angle: Vector2)` 
Sets the angle property of the particle
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetMaxRate`(maxRate: number)` 
Sets the maximum amount of particles that can exist at the same time
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Emit`(rate: number)` 
Emits the specified amount of particles, if none is provided then will use as amount the Rate property
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




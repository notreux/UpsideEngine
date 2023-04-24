# PhysicalObject
!!! info 
	 This object was [Extended from BaseObject](BaseObject.md)
This class is used to create objects with physics
	 
 
# Properties

## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 

___
## [readonly](readonly.md) [number](number.md) <u>ChromaticAberrationIntensity</u> 

___
## [readonly](readonly.md) [number](number.md) <u>ChromaticAberrationDistance</u> 

___
## [readonly](readonly.md) [Vector2](Vector2.md) <u>ChromaticAberrationPoint</u> 
This is the point which is being used as reference for the chromatic aberration
		
___
## [readonly](readonly.md) [table](table.md) <u>ChromaticAberration</u> 
The instances which makes the chromatic aberration effect
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [table](table.md) <u>Collisions</u> 
This table stores all the active collisions
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [boolean](boolean.md) <u>ChromaticAberrationConnection</u> 

___
## [rules](rules.md) [table](table.md) <u>CollisionBlacklist</u> 
This dictionary stores all the blacklisted objects, to blacklist an object do it like this:
		```lua
		CollisionBlacklist[object.Id] = true
		```
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [rules](rules.md) [table](table.md) <u>Hitbox</u> 
!!! warning 
			Experimental, dont use
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [rules](rules.md) [number](number.md) <u>Mass</u> 
The object mass
		
___
## [rules](rules.md) [number](number.md) <u>HitboxScale</u> 

___
## [rules](rules.md) [number](number.md) <u>CollisionGroup</u> 
A number which indicates the collision group of the object, the object only can collide with other objects with the same CollisionGroup
		
___
## [rules](rules.md) [boolean](boolean.md) <u>Anchored</u> 
This property defines if the object should have physics or not
		
___
## [rules](rules.md) [boolean](boolean.md) <u>CanCollide</u> 
This property defines if the object can collide with other objects
		
___
## [rules](rules.md) [boolean](boolean.md) <u>IsGrounded</u> 
This property indicates if the object is touching the ground
		
___
## [rules](rules.md) [boolean](boolean.md) <u>TrackCollisions</u> 
This property defines if the object is going to have physics and collisions or not
		
___
## [rules](rules.md) [string](string.md) <u>HitboxShape</u> 
!!! warning 
			Experimental, dont use
	
___
## [rules](rules.md) [Vector2](Vector2.md) <u>Force</u> 
Is the force which is applied in the moment to the object
		
___
## [rules](rules.md) [Vector2](Vector2.md) <u>Velocity</u> 
Is the velocity applied to the object
		
___


# Methods

### [PhysicalObject](PhysicalObject.md) Constructor`()` 

___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetHitboxShape`(shape: string)` 
!!! warning 
		Sets the hitbox shape. Experimental, dont use
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Load`(url: string)` 
Loads an image for the current object and is set as the instance image
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetChromaticAberration`(Intensity: number, Distance: number, Point: Vector2)` 
Sets chromatic aberration for the image using a center as reference, by default the center is the middle of the screen, 
	to disable the chromatic aberration send 0 as first parameter
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|Collision|Params -> [PhysicalObject](PhysicalObject.md)<br>This event is fired when the object collides with other object<br>|
|CollisionEnd|Params -> [PhysicalObject](PhysicalObject.md)<br>This event is fired when the object finish the collision with other object<br>|




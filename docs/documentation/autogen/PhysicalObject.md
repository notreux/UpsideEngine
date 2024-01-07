# [Extended from BaseObject](BaseObject.md) PhysicalObject 
This class is used to create objects with physics
	 
# Properties

## [Vector2](Vector2.md) ChromaticAberrationPoint
This is the point which is being used as reference for the chromatic aberration
		
## [Vector2](Vector2.md) Force
Is the force which is applied in the moment to the object
		
## [Vector2](Vector2.md) Velocity
Is the velocity applied to the object
		
## [table](table.md) ChromaticAberration 
The instances which makes the chromatic aberration effect
		 
```lua
{ }
```
## [table](table.md) Collisions 
This table stores all the active collisions
		 
```lua
{ }
```
## [table](table.md) CollisionBlacklist 
This dictionary stores all the blacklisted objects, to blacklist an object do it like this:
		```lua
		CollisionBlacklist[object.Id] = true
		```
		 
```lua
{ }
```
## [table](table.md) Hitbox 
This the CollisionMask of the object
	 
```lua
{ }
```
## [number](number.md) Mass
The object mass
		
## [number](number.md) HitboxScale

## [number](number.md) CollisionGroup
A number which indicates the collision group of the object, the object only can collide with other objects with the same CollisionGroup
		
## [number](number.md) ChromaticAberrationIntensity

## [number](number.md) ChromaticAberrationDistance

## [boolean](boolean.md) Anchored
This property defines if the object should have physics or not
		
## [boolean](boolean.md) CanCollide
This property defines if the object can collide with other objects
		
## [boolean](boolean.md) IsGrounded
This property indicates if the object is touching the ground
		
## [boolean](boolean.md) TrackCollisions
This property defines if the object is going to have physics and collisions or not
		
## [boolean](boolean.md) ChromaticAberrationConnection



# Methods

## [PhysicalObject](PhysicalObject.md) Constructor(` `) 
 
## [void](https://create.roblox.com/docs/scripting/luau/nil) Load(`url: string `) 
 Loads an image for the current object and is set as the instance image
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetChromaticAberration(`Intensity: number, Distance: number, Point: Vector2 `) 
 Sets chromatic aberration for the image using a center as reference, by default the center is the middle of the screen, 
	to disable the chromatic aberration send 0 as first parameter
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|Collision|Params -> [PhysicalObject](PhysicalObject.md)<br>This event is fired when the object collides with other object<br>|
|CollisionEnd|Params -> [PhysicalObject](PhysicalObject.md)<br>This event is fired when the object finish the collision with other object<br>|




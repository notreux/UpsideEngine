# [Extended from BaseObject](BaseObject.md) Particle 
!!! warning 
  	Currently it's recommended to use sprites to make particles/vfx, this class is in experimental state and can change a lot

  _____
  This class is used for vfx

	 
# Properties

## [Vector2](Vector2.md) Angle
Depending on the value the particles will be more dispersed
  
## [TweenInfo](TweenInfo.md) Info
Is the tween info of the tween which is going to be used to move the particles
  
## [boolean](boolean.md) Enabled
When its enabled new particles can be emitted
  
## [number](number.md) Rotation
Rotation in degrees applied to the emission direction (offset for theta)

## [number](number.md) MaxRate
Is the maximum amount of particles that can exist at the same time
  
## [number](number.md) Units
Is the amount of particles that are existing at this moment
  
## [number](number.md) Range
Is the distance that can be traveled by each particle 
  
## [number](number.md) LifeTime
The number of seconds the particle will be active before being destroyed
  
## [number](number.md) Clock
Used for internal purposes
  
## [number](number.md) Rate
Is the amount of particles which is going to be generated
  
## [Character](Character.md) Subject
The subject which is going to be the center of emission of the particle, a character, sprite, etc...
  
## [table](table.md) Properties 
Is a table with the initial properties of the particle which is going to be generated
   
```lua
{
 	["Image"]: string,
}
```
## [table](table.md) Goals 
Is a table with the goals of the particles
   
```lua
{
 	["Size"]: UDim2,
	["ImageTransparency"]: number,
}
```


# Methods
## [void](void.md) SetSubject(`subject: Character`) 
 Sets the subject property

## [void](void.md) SetAngle(`Angle: Vector2`) 
 Sets the angle property of the particle

## [void](void.md) SetMaxRate(`maxRate: number`) 
 Sets the maximum amount of particles that can exist at the same time

## [void](void.md) SetRotation(`rotation: number`) 
 
## [void](https://create.roblox.com/docs/scripting/luau/nil) Emit(`rate: number?`) 
 Emits the specified amount of particles, if none is provided then will use as amount the Rate property
    


# Events
There is no events for this class



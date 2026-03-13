# [Extended from StaticObject](StaticObject.md) PhysicalObject 
This class is used to create objects with physics
	 
# Properties

## [Vector2](Vector2.md) Force
Is the force which is applied in the moment to the object
  
## [Vector2](Vector2.md) Velocity
Is the velocity applied to the object
  
## [Vector2](Vector2.md) Acceleration
Defines the rate of change of velocity for the physical object, initially set to zero.
  
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
## [string](string.md) Shape
Specifies the geometric shape of the physical object, which can be "circle" and "custom" for polygons, custom is has box hitbox by default, also is the default shape.
  
## [number](number.md) Mass
The object mass
  
## [number](number.md) HitboxScale
Change this property to change the hitbox size, the default value is 1
  
## [number](number.md) CollisionGroup
A number which indicates the collision group of the object, the object only can collide with other objects with the same CollisionGroup
  
## [number](number.md) Friction
Determines the resistance to sliding motion between this object and another surface, influencing how quickly it slows down.
  
## [number](number.md) AngularVelocity
The rotational speed of the object in degrees per second.
  
## [number](number.md) AngularFriction
Determines how quickly the angular velocity decays over time.
  
## [number](number.md) AngularScale
Multiplier for collision-generated spin. Defaults to 0 (disabled). Set to 1 or higher to enable angular physics.
  
## [number](number.md) AngularStiffness
How strongly the object snaps to stable angles when grounded. Higher = faster settling, lower = more wobbly. Set to 0 to disable auto-stabilization.
  
## [number](number.md) Torque
The rotational force applied to the object this frame.
	
## [boolean](boolean.md) Anchored
This property defines if the object should have physics or not
  
## [boolean](boolean.md) CanCollide
This property defines if the object can collide with other objects
  
## [boolean](boolean.md) IsGrounded
This property indicates if the object is touching the ground
  
## [boolean](boolean.md) TrackCollisions
This property defines if the object is going to have physics and collisions or not
  


# Methods
## [void](PhysicalObject.md) ApplyForce(`force: Vector2`) 
 Applies force to the object
	
## [void](PhysicalObject.md) ApplyTorque(`torque: number`) 
 Applies torque to the object (rotational force in degrees/s²)
	


# Events
|<div style="width:100%; max-size: 100%">Name</div>|<div style="width:100%; max-size: 100%">Description</div>|
|---|---|
|Collision|Params -> [PhysicalObject](PhysicalObject.md)<br>  This event is fired when the object collides with other object<br>  |
|CollisionEnd|Params -> [PhysicalObject](PhysicalObject.md)<br>  This event is fired when the object finish the collision with other object<br>|




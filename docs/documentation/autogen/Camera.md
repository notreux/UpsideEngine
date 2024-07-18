# [Extended from EventEmitter](EventEmitter.md) Camera 
This class is included on every scene, it's used to move you around the scene
	 
# Properties

## [UDim2](UDim2.md) OffsetPosition

## [Vector2](Vector2.md) LocalPosition
This property is used to move the camera internally
  
## [Vector2](Vector2.md) Limits
This property marks the limits to move the camera, for example, if you set `Vector2.new(0.5, 0.5)` the camera will move only when it reaches the limit
  
## [boolean](boolean.md) FollowSubject
This property defines if the camera is going to follow the defined subject
  
## [string](string.md) Scene

## [number](number.md) Smoothness
This property defines the smoothness with which the camera will move, it only works in a range between 0 and 1

## [Character](Character.md) Subject
This property defines the object which is going to follow the camera
  


# Methods

## [UDim2](https://create.roblox.com/docs/reference/engine/datatypes/UDim2) GetPosition() 
 Gets the camera position
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetPosition(`udim2: UDim2`) 
 Sets the camera position
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetSubject(`subject: Character`) 
 Sets the camera subject
	
## [void](void.md) LookTo(`object: PhysicalObject`) 
 

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




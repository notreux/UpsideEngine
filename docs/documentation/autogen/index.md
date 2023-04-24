

# BaseObject
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class is the base class of the majority of classes
	 
 
# Properties

## [readonly](readonly.md) [Instance](Instance.md) <u>Instance</u> 
The object instance
		
___
## [readonly](readonly.md) [string](string.md) <u>Scene</u> 
The object scene ID
		
___
## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 
The class name of the object instance
		
___
## [readonly](readonly.md) [table](table.md) <u>Tags</u> 
This table stores all the tags of the object
 
???+ Content 
	```lua 
	{ 	} 
	```


# Methods

### [BaseObject](BaseObject.md) Constructor`(parent: Scene)` 

___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Set`(properties: Dictionary<string, any>)` 
Sets the properties of the object instance
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) AddTag`(tag: string)` 
Adds a tag to the object
	
___
### [boolean](https://create.roblox.com/docs/scripting/luau/booleans) HasTag`(tag: string)` 
Checks if the object contain the specified tag
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) RemoveTag`(tag: string)` 
Removes a tag from the object
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# Camera
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class is included on every scene, it's used to move you around the scene
	 
 
# Properties

## [readonly](readonly.md) [Character](Character.md) <u>Subject</u> 
This property defines the object which is going to follow the camera
		
___
## [rules](rules.md) [boolean](boolean.md) <u>FollowSubject</u> 
This property defines if the camera is going to follow the defined subject

___


# Methods

### [Camera](Camera.md) Constructor`(scene: Scene)` 

___
### [void](https://create.roblox.com/docs/reference/engine/datatypes/UDim2) GetPosition`()` 
Gets the camera position
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetPosition`(udim2: UDim2)` 
Sets the camera position
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetSubject`(subject: Character)` 
Sets the camera subject
	
___
### [void](void.md) LookTo`(object: PhysicalObject)` 

___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# Connection
!!! info 
	 This object was [Extended from BaseClass](BaseClass.md)
This class is used in the event emitter class, its used to manage a listener
	 
 
# Properties

## [readonly](readonly.md) [boolean](boolean.md) <u>Active</u> 
Defines if the connection is active or not

___


# Methods

### [Connection](Connection.md) Constructor`(eventId: number, event: Dictionary<string, table>)` 

___
### [thread?](https://create.roblox.com/docs/reference/engine/libraries/coroutine) Wait`(seconds: number?)` 
Wait until the event gets fired, if seconds were specified, once the specified seconds have elapsed, it will stop waiting
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Disconnect`()` 
Deletes the connection and the listener
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# EventEmitter
!!! info 
	 This object was [Extended from BaseClass](BaseClass.md)
The event emitter is used to manage the events of a class
	 
 
# Properties

## [readonly](readonly.md) [table](table.md) <u>EventsStorage</u> 
This table store all the events of the class
 
???+ Content 
	```lua 
	{ 	} 
	```


# Methods

### [Connection](Connection.md) On`(name: string, callback: () -> ())` 

___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Fire`(name: string, ...any)` 
Triggers an event with the specified arguments
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





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





# ParticleEnvironment
!!! info 
	 This object was [Extended from Environment](Environment.md)
 
 
# Properties



# Methods


# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# Request
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class is used for the client replication
	 
 
# Properties

## [readonly](readonly.md) [table](table.md) <u>Content</u> 
The content of the request
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [number](number.md) <u>ClientId</u> 
The UserId of the client which sent the request if exists 
	
___


# Methods

### [Request](Request.md) Constructor`(clientId: number, content: Dictionary<string, any>)` 

___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Send`(content: Dictionary<string, any>)` 
Sends the request to the server
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Approve`(clients: table)` 
The request is approved and its replicated to the specified clients, if none is specified it will be replicated to all the clients except to the client who sent the request
	
___
### [BaseObject](BaseObject.md) Accept`(...any)` 
Accepts the request and builds the object to be replicated
	
___
### [void](https://create.roblox.com/docs/reference/engine/classes/Player) GetClient`()` 
Returns the player which sent the request
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|Build|Params -> [BaseObject](BaseObject.md)<br>Fired when a request is accepted and the object to be replicated is being built<br>|





# SoundEnvironment
!!! info 
	 This object was [Extended from Environment](Environment.md)
 
 
# Properties

## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 

___


# Methods


# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# Character
!!! info 
	 This object was [Extended from Sprite](Sprite.md)
This class is used for the player character and for npcs
	 
 
# Properties

## [readonly](readonly.md) [number](number.md) <u>Health</u> 
The amount of health of the character
		
___
## [rules](rules.md) [number](number.md) <u>MaxHealth</u> 
The maximum amount of health of the character 
		
___
## [rules](rules.md) [number](number.md) <u>WalkSpeed</u> 
The walk speed of the character
		
___
## [rules](rules.md) [number](number.md) <u>JumpPower</u> 
The jump power of the character

___


# Methods

### [void](https://create.roblox.com/docs/scripting/luau/nil) UpdateHealth`(Health: number)` 
Updates the amount of health of the character 
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Jump`(jumpPower: number?)` 
The character jumps with the provided jump power, if none is provided it will use the JumpPower property as value 
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) MoveTo`(target: Vector2)` 
The character walks directly to the provided position
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# Environment
!!! info 
	 This object was [Extended from BaseObject](BaseObject.md)
This class is used to storage objects and interact with them in an easier way
	 
 
# Properties

## [rules](rules.md) [table](table.md) <u>Content</u> 
 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [number](number.md) <u>Count</u> 
The amount of objects in this environment

___
## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 

___


# Methods

### [Environment](Environment.md) Constructor`()` 

___
### [any](any.link) Get`(index: string)` 
Gets the object with the specified index
	
___
### [void](any.link) AddOne`(value: any, index: string)` 
Adds an object with the specified index, if no parameter is specified it will use the next number of the count property as index
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) RemoveOne`(index: string)` 
Removes the object with the specified index
	
___
### [boolean](https://create.roblox.com/docs/scripting/luau/booleans) HasOne`(index: string)` 
Checks if the environment has a value with the specified index
	
___
### [(boolean, Dictionary<string, boolean>)](https://create.roblox.com/docs/scripting/luau/booleans) Has`(objects: Array<string>)` 
Checks if the environment contains every specified index and returns a boolean and a dictionary with boolean values, example:
	```lua
	local hasAll, dictionary = treeEnv:Has({
		"Tree1",
		"Tree2",
		"Tree4"
	})

	print(hasAll, dictionary) -- output: false, { Tree1 = true, Tree2 = true, Tree4 = false }
	```
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Add`(objects: Dictionary<string, any>)` 
Adds objects with the specified index
	```lua
	treeEnv:Add({
		"Tree1" = tree:new(),
		"Tree2" = tree:new(),
		"Tree3" = tree:new()
	})

	print(treeEnv:Get("Tree2")) -- output: Tree2
	```
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Remove`(objects: Array<string>)` 
Removes the objects with the specified index, example:
	```lua
	treeEnv:Remove({ "Tree1", "Tree2", "Tree3" })
	print(treeEnv:Get("Tree2")) -- output: nil
	```
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Update`(objects: Dictionary<string, any>)` 
Updates the objects with the specified index, example:
	```lua
	treeEnv:Update({
		Tree1 = treeEnv:Get("Tree2"),
		Tree2 = treeEnv:Get("Tree1"),
	})
	```
	
___
### [any](any.link) FindByName`(name: string)` 
Finds an object by his name
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetProperty`(property: string, value: any)` 
Sets the specified property in every object in the environment
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Run`(method: string, ...any)` 
Executes the specified methods in every object in the environment with the specified parameters
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# Light
!!! info 
	 This object was [Extended from PhysicalObject](PhysicalObject.md)
This class is used to illuminate areas in the darkness
	 
 
# Properties

## [readonly](readonly.md) [boolean](boolean.md) <u>TrackCollisions</u> 
Its a property of PhysicalObject, in this class is marked as readonly and is set false to optimizate
		
___
## [rules](rules.md) [Color3](Color3.md) <u>Color</u> 

___
## [rules](rules.md) [number](number.md) <u>Range</u> 
Is the range of the light
		
___
## [rules](rules.md) [number](number.md) <u>Brightness</u> 
Is the brightness of the light
		
___
## [rules](rules.md) [boolean](boolean.md) <u>Track</u> 
If this property is set to true the light is tracked, so it appears on the screen, if it is disabled and it was tracked at some point,
		it will appear on the screen but if at any time another light enters in the range of this light, this light will start to modify the shape of the initial light, that's because we can say that when we disable the
		the shape of the initial light, that is because it could be said that when we disable the Track property what remains on the screen is the trace of the light.

___


# Methods

### [Light](Light.md) Constructor`(scene: Scene)` 

___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





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





# Scene
!!! info 
	 This object was [Extended from BaseObject](BaseObject.md)
This class is useful to have a workspace and manage your project more easily
	 
 
# Properties

## [readonly](readonly.md) [table](table.md) <u>Objects</u> 
This table stores all the objects in the scene
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 

___
## [readonly](readonly.md) [SoundEnvironment](SoundEnvironment.md) <u>SoundEnvironment</u> 
This is the SoundEnvironment of the scene
		
___
## [readonly](readonly.md) [ParticleEnvironment](ParticleEnvironment.md) <u>ParticleEnvironment</u> 
This is the ParticleEnvironment of the scene
		
___
## [readonly](readonly.md) [LightingEnvironment](LightingEnvironment.md) <u>LightingEnvironment</u> 
This is the LightingEnvironment of the scene

___


# Methods

### [Scene](Scene.md) Constructor`(parent: Instance)` 

___
### [void](https://create.roblox.com/docs/scripting/luau/nil) AddObject`(object: BaseObject)` 
Adds the specified object
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) RemoveObject`(object: BaseObject)` 
Removes the specified object
	
___
### [BaseObject?](BaseObject.md) FindByName`(name: string)` 
Finds an object by his name
	
___
### [boolean](https://create.roblox.com/docs/scripting/luau/booleans) HasObject`(object: BaseObject)` 
Checks if the object is in the scene
	
___
### [Array<string>](https://create.roblox.com/docs/scripting/luau/tables#arrays) GetTaggedObjects`(tag: string)` 
Gets all the objects with the provided tags in the scene
	
___
### [Raycast2dResult](/documentation/datatypes/Raycast2DResult.html) Raycast`(info: Raycast2dParams)` 
Casts a ray using the Raycast2dParams. If it finds an elegible object a Raycast2dResult is returned containing the results of the operations
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# Sound
!!! info 
	 This object was [Extended from BaseObject](BaseObject.md)
This class is used to play sounds
	 
 
# Properties

## [readonly](readonly.md) [string](string.md) <u>InstanceType</u> 

___
## [readonly](readonly.md) [Character](Character.md) <u>Subject</u> 
This table stores all the objects in the scene
		
___
## [rules](rules.md) [number](number.md) <u>Range</u> 
This is the SoundEnvironment of the scene
		
___
## [rules](rules.md) [number](number.md) <u>MaxVolume</u> 
This is the ParticleEnvironment of the scene
		
___
## [rules](rules.md) [boolean](boolean.md) <u>DistanceFading</u> 
The volume will depend on the player distance

___


# Methods

### [void](https://create.roblox.com/docs/scripting/luau/nil) SetSubject`(subject: Character, useSceneSoundGroup: boolean?)` 
Sets the provided character as subject, if is provided a sound group, this will be the new sound group of the sound
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# Sprite
!!! info 
	 This object was [Extended from PhysicalObject](PhysicalObject.md)
This class is used to play sounds
	 
 
# Properties

## [readonly](readonly.md) [boolean](boolean.md) <u>IsPlaying</u> 
Indicates if the sprite is playing
		
___
## [readonly](readonly.md) [table](table.md) <u>Active</u> 
This table stores information about the active spritesheet
 
???+ Content 
	```lua 
	{
 		Name: string,
		CurrentFrame: Vector2,
		SecondsPerFrame: number,
		NextStepReady: boolean,
	} 
	```
## [rules](rules.md) [number](number.md) <u>SecondsPerFrame</u> 
This is the time to wait between frame and frame
		
___
## [rules](rules.md) [table](table.md) <u>Sprites</u> 
This table stores all sprite sheets and sprite lists 
		 
???+ Content 
	```lua 
	{ 	} 
	```


# Methods

### [Sprite](Sprite.md) Constructor`(parent: Scene, size: Vector2)` 
The second parameter is the size of a cell of every frame of an sprite sheet, this can be changed using the .ImageRectSize property of the object Instance 
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetSpriteSheet`(name: string, url: string, frames: Vector2)` 
Adds a new sprite sheet to the object, the sprite will be played using as reference the amount of cells in the X axe and the Y axe, this must be provided in the third paramether as a Vector2
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetSpriteList`(name: string, list: Array<string>)` 
Adds a new sprite list to the object, it will play the animation using the order in the provided list, this list must contain the urls of every frame
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Play`(name: string, secondsPerFrame: number?)` 
Plays the specified sprite if exists, if secondsEveryFrame is specified it will be used instead of .SecondsPerFrame
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Stop`()` 
Stops the reproduction of the current playing sprite sheet or sprite list
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# CrossPlatformService
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class is used to make the controls functional in any device (Keyboards, Mobiles, Gamepads), this service vinculate actions 
	to specified keys, and also provides a movement system for the player character which can be disabled with the `DefaultControllersEnabled`
	property, here is an example to make our player jumps in every device:
```lua
--  								Device,	    Key, 	Action
CrossPlatformService:SetDeviceKey("Keyboard", "Space", "Jump")
CrossPlatformService:SetDeviceKey("Mobile", "JumpButton", "Jump")
CrossPlatformService:SetDeviceKey("Gamepad", "ButtonA", "Jump")
```


But this is not limited only to movement actions, you can also assign other kind of actions, for example:


```lua
CrossPlatformService:SetDeviceKey("Keyboard", "E", "Collect")
CrossPlatformService:SetDeviceKey("Mobile", "JumpButton", "Collect")
CrossPlatformService:SetDeviceKey("Gamepad", "ButtonA", "Collect")
```


We assigned an action for our devices but how can we detect when an action is triggered? well we can listen to three events
"InputBegin", "InputChange", "InputEnd", example of use:


```lua
-- If the movement belongs to a stick, the second parameter will give the current position of the stick
CrossPlatformService:On("InputBegin", function(action, position)
	local character = CrossPlatformService.Character

	if action == "Jump" then
		character:Jump(150)
	end
end)
```

	 
 
# Properties

## [rules](rules.md) [boolean](boolean.md) <u>DefaultControllersEnabled</u> 
Defines if the default movement system is enabled
		
___
## [rules](rules.md) [boolean](boolean.md) <u>SideView</u> 
Defines if the character is going to be seen from the side or from the top
		
___
## [readonly](readonly.md) [Character](Character.md) <u>Character</u> 
This is the character which is going to be tracked by the camera
		
___
## [readonly](readonly.md) [number](number.md) <u>StickSensibility</u> 
This is the sensibility of the sticks in mobile and in game controllers
		
___
## [readonly](readonly.md) [table](table.md) <u>Configs</u> 
This table stores the default controllers
	 
???+ Content 
	```lua 
	{
 		Keyboard: 	{
 		W: string,
		A: string,
		S: string,
		D: string,
		Up: string,
		Left: string,
		Down: string,
		Right: string,
		Space: string,
	},
		Gamepad: 	{
 		ButtonA: string,
		Thumbstick1: 	{
 		Up: string,
		Left: string,
		Down: string,
		Right: string,
	},
	},
		Mobile: 	{
 		JumpButton: string,
		Thumbstick1: 	{
 		Up: string,
		Left: string,
		Down: string,
		Right: string,
	},
	},
	} 
	```


# Methods

### [void](https://create.roblox.com/docs/scripting/luau/nil) SetDeviceKey`(device: string, key: string, action: string)` 
Assigns an action to a device key, example:
	```lua
	CrossPlatformService:SetDeviceKey("Keyboard", "Space", "Jump")
	```
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetDeviceConfig`(device: string, controls: Dictionary<string, string?>)` 
Sets the entire configuration of a device, example:
	```lua
	CrossPlatformService:SetDeviceConfig("Keyboard", {
		W = "Up",
		A = "Left",
		S = "Down",
		D = "Right",

		Up = "Up",
		Left = "Left",
		Down = "Down",
		Right = "Right",
		Space = "Jump",
	})
	```
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SetPlayerCharacter`(character: Character)` 
Sets the player character
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|InputBegin|Params -> [UpsideEngineInput](/documentation/datatypes/UpsideEngineInput.html) <br>Fired when one of the keys/sticks in the configuration is pressed/moved<br>|
|InputChange|Params -> [UpsideEngineInput](/documentation/datatypes/UpsideEngineInput.html) <br>Fired when the an active input change its value, for example the position of a stick<br>|
|InputEnd|Params -> [UpsideEngineInput](/documentation/datatypes/UpsideEngineInput.html) <br>Fired when one of the keys/sticks in the configuration finish to be pressed/moved<br>|





# NetworkingService
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class is to replicate objects to other clients, for example the player character
	 
 
# Properties

## [readonly](readonly.md) [table](table.md) <u>Players</u> 
A dictionary with the replicated objects by the clients
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [rules](rules.md) [boolean](boolean.md) <u>DestroyObjectsOnLeave</u> 
Defines if the replicated objects by other clients should be destroyed when they leaves
	
___


# Methods

### [void](void.md) Replicate`(object: BaseObject)` 
Replicates an object to other clients

___
### [(Connection, Connection)](Connection.md) ReplicateOnChange`(object: BaseObject)` 
Replicates an object and each change on it, and returns the connections that detect each change of the object
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|ReplicationRequest|Params -> [Request](Request.md) <br>Fired when a request is received by the client<br>|





# PluginSupportService
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class save and build the engine data
 
 
# Properties



# Methods

### [void](https://create.roblox.com/docs/scripting/luau/nil) LoadPluginContent`()` 
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) SavePluginContent`(content: {})` 
Saves the engine data in replicated storage as attribute with the name "UpsideEngineDB" can be useful to create plugins
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|





# SceneManager
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class save and build the engine data
	 
 
# Properties

## [readonly](readonly.md) [table](table.md) <u>Scenes</u> 
 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [table](table.md) <u>ActiveScenes</u> 
This dictionary stores all the active scenes
	 
???+ Content 
	```lua 
	{ 	} 
	```


# Methods

### [void](https://create.roblox.com/docs/scripting/luau/nil) Load`(scene: Scene)` 
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Unload`(scene: Scene)` 
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
___
### [Scene?](https://create.roblox.com/docs/scripting/luau/nil) FindByName`(name: string)` 
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
___
### [Scene](https://create.roblox.com/docs/scripting/luau/nil) Get`(Id: string)` 
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|SceneLoaded|Params -> [Scene](Scene.md) <br>Fired when a scene is loaded<br>|
|SceneUnloaded|Params -> [Scene](Scene.md) <br>Fired when a scene is unloaded<br>|






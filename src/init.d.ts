// THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.

declare function addReadonly(readonly: Dictionary<string, any>): () => any;

declare interface table {}
declare interface Dictionary<k,v> extends Record<any, any> {}
declare interface ChromaticAberrationConnection {}

declare interface BaseObjectParams {
	Parent?: Scene,
}

declare interface SceneParams {
	Parent?: Instance,
}

declare interface SpriteParams extends BaseObjectParams {
	SpriteSize?: Vector2,
}

declare interface ConnectionParams {
	EventId: number,
	Event: {
		Functions: {},
		Threads: {},
	},
}

declare interface RequestParams {
	ClientId: number,
	Content: {
		className: string,
		id: string,
		name: string,
		properties: {
			instance: {},
			object: {},
		},
	},
}

declare interface Raycast2dResult { 
    Object: PhysicalObject;
    Position: UDim2;
    Distance: Vector2;
    Normal: UDim2 
}

declare interface Raycast2dParams { 
    Filterinterface: string;
    From: Vector2;
    List: Array<BaseObject>;
    To: any 
}

declare interface ClassData {
	name: string,
	constructor?: Dictionary<string, () => any>,
	methods?: Dictionary<string, () => any>,
	private?: Dictionary<string, any>,
	readonly?: Dictionary<string, any>,
	rules?: Dictionary<string, any>,
}

declare interface BaseClass {
    Id: string,
    ClassName: string,
	Name: string,
    SetName(name: string): any;
    IsA(self: BaseClass,className: string): boolean;
    new(...any): BaseClass;
    Clone(...any): BaseClass;
    Extend(self: BaseClass,className: string,classStructure: table): BaseClass;
    Destroy(): any;
}/**
This class is the base class of the majority of classes
	ription
*/ 
 export declare interface BaseObject extends EventEmitter {
/**
The object instance
		
*/
Instance: Instance;
/**
The object scene ID
		
*/
Scene: string;
/**
The class name of the object instance
		
*/
InstanceType: string;
/**
This table stores all the tags of the object

*/
Tags: 	{ 	};
/**
Sets the properties of the object instance
	
*/
Set(properties: Dictionary<string, any>): null;
/**
Adds a tag to the object
	
*/
AddTag(tag: string): null;
/**
Checks if the object contain the specified tag
	
*/
HasTag(tag: string): boolean;
/**
Removes a tag from the object
	
*/
RemoveTag(tag: string): null;
}
 



/**
This class is included on every scene, it's used to move you around the scene
	ription
*/ 
 export declare interface Camera extends EventEmitter {
/**
This property defines the object which is going to follow the camera
		
*/
Subject: Character;
/**
This property defines if the camera is going to follow the defined subject

*/
FollowSubject: boolean;
/**
Gets the camera position
	
*/
GetPosition(): null;
/**
Sets the camera position
	
*/
SetPosition(udim2: UDim2): null;
/**
Sets the camera subject
	
*/
SetSubject(subject: Character): null;
/**

*/
LookTo(object: PhysicalObject): null;
}
 



/**
This class is used in the event emitter class, its used to manage a listener
	ription
*/ 
 export declare interface Connection extends BaseClass {
/**
Defines if the connection is active or not

*/
Active: boolean;
/**
Wait until the event gets fired, if seconds were specified, once the specified seconds have elapsed, it will stop waiting
	
*/
Wait(seconds: number | void): thread | void;
/**
Deletes the connection and the listener
	
*/
Disconnect(): null;
}
 



/**
The event emitter is used to manage the events of a class
	ription
*/ 
 export declare interface EventEmitter extends BaseClass {
/**
This table store all the events of the class

*/
EventsStorage: 	{ 	};
/**

*/
On(name: string, callback: () => any): Connection;
/**
Triggers an event with the specified arguments
	
*/
Fire(name: string, ...any): null;
}
 



/**
This class is one of the most important components of a scene, is used to manage everything related with the light 
	ription
*/ 
 export declare interface LightingEnvironment extends Environment {
/**
This is the color of every pixel of the ambient, we can say is the darkness color
		
*/
AmbientColor: Color3;
/**
This is the transparency of the ambient, we can say is the darkness transparency
		
*/
AmbientTransparency: number;
/**
This is the seconds between every update of the pixels in the screen
		
*/
UpdateFrequency: number;
/**
This is the pixel in the middle of every large pixel, used for internal purposes
		
*/
PixelIndex: number;
/**
This is the distance between every large pixel, used for internal purposes

*/
Distance: number;
/**

*/
InstanceType: string;
/**
Stores all the ambient pixels
		
*/
Pixels: 	{ 	};
/**

*/
LightingIntensity: number;
/**
Draws the pixels for the scene with the specified settings
	```lua
		settings = {
			Pixels = 800, -- We can say that is the resolution for the ambient, is limited to 2000
			Resolution = Vector2.new(1080, 1920) -- Defines the resolution to take as reference, is going to use the screen resolution if none is specified
			AutoScale = true -- Defines if the amount of pixels is going to be scaled depending on the resolution
		}
	```
	
*/
DrawPixels(settings: any): null;
/**
Sets the base intensity for all the lights in the scene
	
*/
SetLightingIntensity(value: number): null;
/**
Gets the base intensity for all the lights in the scene 
	
*/
GetLightingIntensity(): null;
/**
Updates the position, the transparency and the color of the ambient
	
*/
UpdateScreen(): null;
}
 



/**
ription
*/ 
 export declare interface ParticleEnvironment extends Environment {
}
 



/**
This class is used for the client replication
	ription
*/ 
 export declare interface Request extends EventEmitter {
/**
The content of the request
		
*/
Content: 	{ 	};
/**
The UserId of the client which sent the request if exists 
	
*/
ClientId: number;
/**
Sends the request to the server
	
*/
Send(content: Dictionary<string, any>): null;
/**
The request is approved and its replicated to the specified clients, if none is specified it will be replicated to all the clients except to the client who sent the request
	
*/
Approve(clients: table): null;
/**
Accepts the request and builds the object to be replicated
	
*/
Accept(data: BaseObjectParams): BaseObject;
/**
Returns the player which sent the request
	
*/
GetClient(): null;
}
 



/**
ription
*/ 
 export declare interface SoundEnvironment extends Environment {
/**

*/
InstanceType: string;
}
 



/**
This class is used for the player character and for npcs
	ription
*/ 
 export declare interface Character extends Sprite {
/**
The amount of health of the character
		
*/
Health: number;
/**
The maximum amount of health of the character 
		
*/
MaxHealth: number;
/**
The walk speed of the character
		
*/
WalkSpeed: number;
/**
The jump power of the character

*/
JumpPower: number;
/**
Updates the amount of health of the character 
	
*/
UpdateHealth(Health: number): null;
/**
The character jumps with the provided jump power, if none is provided it will use the JumpPower property as value 
	
*/
Jump(jumpPower: number | void): null;
/**
The character walks directly to the provided position
	
*/
MoveTo(target: Vector2): null;
}
 



/**
This class is used to storage objects and interact with them in an easier way
	ription
*/ 
 export declare interface Environment extends BaseObject {
/**

*/
Content: 	{ 	};
/**
The amount of objects in this environment

*/
Count: number;
/**

*/
InstanceType: string;
/**
Gets the object with the specified index
	
*/
Get(index: string): any;
/**
Adds an object with the specified index, if no parameter is specified it will use the next number of the count property as index
	
*/
AddOne(value: any, index: string): null;
/**
Removes the object with the specified index
	
*/
RemoveOne(index: string): null;
/**
Checks if the environment has a value with the specified index
	
*/
HasOne(index: string): boolean;
/**
Checks if the environment contains every specified index and returns a boolean and a dictionary with boolean values, example:
	
*/
Has(objects: Array<string>): LuaTuple<[boolean, Dictionary<any, boolean>]>
	;
/**
Adds objects with the specified index
	```lua
	treeEnv:Add({
		"Tree1" = tree.new(),
		"Tree2" = tree.new(),
		"Tree3" = tree.new()
	})

	print(treeEnv:Get("Tree2")) -- output: Tree2
	```
	
*/
Add(objects: Dictionary<string, any>): null;
/**
Removes the objects with the specified index, example:
	```lua
	treeEnv:Remove({ "Tree1", "Tree2", "Tree3" })
	print(treeEnv:Get("Tree2")) -- output: nil
	```
	
*/
Remove(objects: Array<string>): null;
/**
Updates the objects with the specified index, example:
	```lua
	treeEnv:Update({
		Tree1 = treeEnv:Get("Tree2"),
		Tree2 = treeEnv:Get("Tree1"),
	})
	```
	
*/
Update(objects: Dictionary<string, any>): null;
/**
Finds an object by his name
	
*/
FindByName(name: string): any;
/**
Sets the specified property in every object in the environment
	
*/
SetProperty(property: string, value: any): null;
/**
Executes the specified methods in every object in the environment with the specified parameters
	
*/
Run(method: string, ...any): null;
}
 



/**
This class is used to illuminate areas in the darkness
	ription
*/ 
 export declare interface Light extends PhysicalObject {
/**
Its a property of PhysicalObject, in this class is marked as readonly and is set false to optimizate
		
*/
TrackCollisions: boolean;
/**

*/
Color: Color3;
/**
Is the range of the light
		
*/
Range: number;
/**
Is the brightness of the light
		
*/
Brightness: number;
/**
If this property is set to true the light is tracked, so it appears on the screen, if it is disabled and it was tracked at some point,
		it will appear on the screen but if at any time another light enters in the range of this light, this light will start to modify the shape of the initial light, that's because we can say that when we disable the
		the shape of the initial light, that is because it could be said that when we disable the Track property what remains on the screen is the trace of the light.

*/
Track: boolean;
}
 



/**
!!! warning 
		Currently it's recommended to use sprites to make particles/vfx, this class is in experimental state and can change a lot

		_____
		This class is used for vfx

	ription
*/ 
 export declare interface Particle extends BaseObject {
/**
Depending on the value the particles will be more dispersed
		
*/
Angle: Vector2;
/**

*/
InstanceType: string;
/**
The subject which is going to be the center of emission of the particle, a character, sprite, etc...
		
*/
Subject: Character;
/**
Is the maximum amount of particles that can exist at the same time
		
*/
MaxRate: number;
/**
Is the amount of particles that are existing at this moment
		
*/
Units: number;
/**
Is a table with the initial properties of the particle which is going to be generated
		
*/
Properties: 	{
 /**
@desc
*/
Image: string,
	};
/**
Is a table with the goals of the particles
		
*/
Goals: 	{
 /**
@desc
*/
Size: UDim2,
/**
@desc
*/
ImageTransparency: number,
	};
/**
Is the tween info of the tween which is going to be used to move the particles
		
*/
Info: TweenInfo;
/**
!!! warning 
			Experimental, dont use
		
*/
TrackLight: boolean;
/**
!!! warning 
			Experimental, dont use
		
*/
CanCollide: boolean;
/**
When its enabled new particles can be emitted
		
*/
Enabled: boolean;
/**
!!! warning 
			Experimental, dont use
		
*/
LightBrightness: number;
/**
!!! warning 
			Experimental, dont use

*/
LightRange: number;
/**
Is the distance that can be traveled by each particle 
		
*/
Range: number;
/**
The number of seconds the particle will be active before being destroyed
		
*/
LifeTime: number;
/**
Used for internal purposes
		
*/
Clock: number;
/**
Is the amount of particles which is going to be generated
		
*/
Rate: number;
/**
Sets the subject property
	
*/
SetSubject(subject: Character): null;
/**
Sets the angle property of the particle
	
*/
SetAngle(Angle: Vector2): null;
/**
Sets the maximum amount of particles that can exist at the same time
	
*/
SetMaxRate(maxRate: number): null;
/**
Emits the specified amount of particles, if none is provided then will use as amount the Rate property
	
*/
Emit(rate: number): null;
}
 



/**
This class is used to create objects with physics
	ription
*/ 
 export declare interface PhysicalObject extends BaseObject {
/**

*/
InstanceType: string;
/**

*/
ChromaticAberrationIntensity: number;
/**

*/
ChromaticAberrationDistance: number;
/**
This is the point which is being used as reference for the chromatic aberration
		
*/
ChromaticAberrationPoint: Vector2;
/**
The instances which makes the chromatic aberration effect
		
*/
ChromaticAberration: 	{ 	};
/**
This table stores all the active collisions
		
*/
Collisions: 	{ 	};
/**

*/
ChromaticAberrationConnection: boolean;
/**
This dictionary stores all the blacklisted objects, to blacklist an object do it like this:
		```lua
		CollisionBlacklist[object.Id] = true
		```
		
*/
CollisionBlacklist: 	{ 	};
/**
!!! warning 
			Experimental, dont use
		
*/
Hitbox: 	{ 	};
/**
The object mass
		
*/
Mass: number;
/**

*/
HitboxScale: number;
/**
A number which indicates the collision group of the object, the object only can collide with other objects with the same CollisionGroup
		
*/
CollisionGroup: number;
/**
This property defines if the object should have physics or not
		
*/
Anchored: boolean;
/**
This property defines if the object can collide with other objects
		
*/
CanCollide: boolean;
/**
This property indicates if the object is touching the ground
		
*/
IsGrounded: boolean;
/**
This property defines if the object is going to have physics and collisions or not
		
*/
TrackCollisions: boolean;
/**
!!! warning 
			Experimental, dont use
	
*/
HitboxShape: string;
/**
Is the force which is applied in the moment to the object
		
*/
Force: Vector2;
/**
Is the velocity applied to the object
		
*/
Velocity: Vector2;
/**
!!! warning 
		Sets the hitbox shape. Experimental, dont use
	
*/
SetHitboxShape(shape: string): null;
/**
Loads an image for the current object and is set as the instance image
	
*/
Load(url: string): null;
/**
Sets chromatic aberration for the image using a center as reference, by default the center is the middle of the screen, 
	to disable the chromatic aberration send 0 as first parameter
	
*/
SetChromaticAberration(Intensity: number, Distance: number, Point: Vector2): null;
}
 



/**
This class is useful to have a workspace and manage your project more easily
	ription
*/ 
 export declare interface Scene extends BaseObject {
/**
This table stores all the objects in the scene
		
*/
Objects: 	{ 	};
/**

*/
InstanceType: string;
/**
This is the SoundEnvironment of the scene
		
*/
SoundEnvironment: SoundEnvironment;
/**
This is the ParticleEnvironment of the scene
		
*/
ParticleEnvironment: ParticleEnvironment;
/**
This is the LightingEnvironment of the scene

*/
LightingEnvironment: LightingEnvironment;
/**
Adds the specified object
	
*/
AddObject(object: BaseObject): null;
/**
Removes the specified object
	
*/
RemoveObject(object: BaseObject): null;
/**
Finds an object by his name
	
*/
FindByName(name: string): BaseObject | void;
/**
Checks if the object is in the scene
	
*/
HasObject(object: BaseObject): boolean;
/**
Gets all the objects with the provided tags in the scene
	
*/
GetTaggedObjects(tag: string): Array<string>;
/**
Casts a ray using the Raycast2dParams. If it finds an elegible object a Raycast2dResult is returned containing the results of the operations
	
*/
Raycast(info: Raycast2dParams): Raycast2dResult;
}
 



/**
This class is used to play sounds
	ription
*/ 
 export declare interface Sound extends BaseObject {
/**

*/
InstanceType: string;
/**
This table stores all the objects in the scene
		
*/
Subject: Character;
/**
This is the SoundEnvironment of the scene
		
*/
Range: number;
/**
This is the ParticleEnvironment of the scene
		
*/
MaxVolume: number;
/**
The volume will depend on the player distance

*/
DistanceFading: boolean;
/**
Sets the provided character as subject, if is provided a sound group, this will be the new sound group of the sound
	
*/
SetSubject(subject: Character, useSceneSoundGroup: boolean | void): null;
}
 



/**
This class is used to play sounds
	ription
*/ 
 export declare interface Sprite extends PhysicalObject {
/**
Indicates if the sprite is playing
		
*/
IsPlaying: boolean;
/**
This table stores information about the active spritesheet

*/
Active: 	{
 /**
@desc
*/
Name: string,
/**
@desc
*/
CurrentFrame: Vector2,
/**
@desc
*/
SecondsPerFrame: number,
/**
@desc
*/
NextStepReady: boolean,
	};
/**
This is the time to wait between frame and frame
		
*/
SecondsPerFrame: number;
/**
This table stores all sprite sheets and sprite lists 
		
*/
Sprites: 	{ 	};
/**
Adds a new sprite sheet to the object, the sprite will be played using as reference the amount of cells in the X axe and the Y axe, this must be provided in the third paramether as a Vector2
	
*/
SetSpriteSheet(name: string, url: string, frames: Vector2): null;
/**
Adds a new sprite list to the object, it will play the animation using the order in the provided list, this list must contain the urls of every frame
	
*/
SetSpriteList(name: string, list: Array<string>): null;
/**
Plays the specified sprite if exists, if secondsEveryFrame is specified it will be used instead of .SecondsPerFrame
	
*/
Play(name: string, secondsPerFrame: number | void): null;
/**
Stops the reproduction of the current playing sprite sheet or sprite list
	
*/
Stop(): null;
}
 



/**
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

	ription
*/ 
 export declare interface CrossPlatformService extends EventEmitter {
/**
Defines if the default movement system is enabled
		
*/
DefaultControllersEnabled: boolean;
/**
Defines if the character is going to be seen from the side or from the top
		
*/
SideView: boolean;
/**
This is the character which is going to be tracked by the camera
		
*/
Character: Character;
/**
This is the sensibility of the sticks in mobile and in game controllers
		
*/
StickSensibility: number;
/**
This table stores the default controllers
	
*/
Configs: 	{
 /**
@desc
*/
Keyboard: 	{
 /**
@desc
*/
W: string,
/**
@desc
*/
A: string,
/**
@desc
*/
S: string,
/**
@desc
*/
D: string,
/**
@desc
*/
Up: string,
/**
@desc
*/
Left: string,
/**
@desc
*/
Down: string,
/**
@desc
*/
Right: string,
/**
@desc
*/
Space: string,
	},
/**
@desc
*/
Gamepad: 	{
 /**
@desc
*/
ButtonA: string,
/**
@desc
*/
Thumbstick1: 	{
 /**
@desc
*/
Up: string,
/**
@desc
*/
Left: string,
/**
@desc
*/
Down: string,
/**
@desc
*/
Right: string,
	},
	},
/**
@desc
*/
Mobile: 	{
 /**
@desc
*/
JumpButton: string,
/**
@desc
*/
Thumbstick1: 	{
 /**
@desc
*/
Up: string,
/**
@desc
*/
Left: string,
/**
@desc
*/
Down: string,
/**
@desc
*/
Right: string,
	},
	},
	};
/**
Assigns an action to a device key, example:
	```lua
	CrossPlatformService:SetDeviceKey("Keyboard", "Space", "Jump")
	```
	
*/
SetDeviceKey(device: string, key: string, action: string): null;
/**
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
	
*/
SetDeviceConfig(device: string, controls: Dictionary<string, string>): null;
/**
Sets the player character
	
*/
SetPlayerCharacter(character: Character): null;
}
 



/**
This class is to replicate objects to other clients, for example the player character
	ription
*/ 
 export declare interface NetworkingService extends EventEmitter {
/**
A dictionary with the replicated objects by the clients
		
*/
Players: 	{ 	};
/**
Defines if the replicated objects by other clients should be destroyed when they leaves
	
*/
DestroyObjectsOnLeave: boolean;
/**
Replicates an object to other clients

*/
Replicate(object: BaseObject): null;
/**
Replicates an object and each change on it, and returns the connections that detect each change of the object
	
*/
ReplicateOnChange(object: BaseObject): LuaTuple<[Connection, Connection]>
;
}
 



/**
This class save and build the engine data
ription
*/ 
 export declare interface PluginSupportService extends EventEmitter {
/**
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
*/
LoadPluginContent(): null;
/**
Saves the engine data in replicated storage as attribute with the name "UpsideEngineDB" can be useful to create plugins
	
*/
SavePluginContent(content: {}): null;
}
 



/**
This class save and build the engine data
	ription
*/ 
 export declare interface SceneManager extends EventEmitter {
/**

*/
Scenes: 	{ 	};
/**
This dictionary stores all the active scenes
	
*/
ActiveScenes: 	{ 	};
/**
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
*/
Load(scene: Scene): null;
/**
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
*/
Unload(scene: Scene): null;
/**
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
*/
FindByName(name: string): Scene | void;
/**
Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	
*/
Get(Id: string): Scene;
}
 



interface upsideEngine {
	Version: string;
	Workspace: {};
	new: ((name: "PhysicalObject", data: BaseObjectParams) => PhysicalObject)
		& ((name: "Sprite", data: SpriteParams) => Sprite)
		& ((name: "Sound", data: BaseObjectParams) => Sound)
		& ((name: "Environment", data: BaseObjectParams) => Environment)
		& ((name: "Light", data: BaseObjectParams) => Light)
		& ((name: "Character", data: SpriteParams) => Character)
		& ((name: "Scene", data: SceneParams) => Scene)
		& ((name: "Particle", data: BaseObjectParams) => Particle),

	Extend: ((name: "PhysicalObject", classData: ClassData) => PhysicalObject)
		& ((name: "Sprite", classData: ClassData) => Sprite)
		& ((name: "Sound", classData: ClassData) => Sound)
		& ((name: "Environment", classData: ClassData) => Environment)
		& ((name: "Light", classData: ClassData) => Light)
		& ((name: "Character", classData: ClassData) => Character)
		& ((name: "Scene", classData: ClassData) => Scene)
		& ((name: "Particle", classData: ClassData) => Particle)

	GetService: ((name: "SceneManager") => SceneManager)
		& ((name: "PluginSupportService") => PluginSupportService)
		& ((name: "NetworkingService") => NetworkingService)
		& ((name: "CrossPlatformService") => CrossPlatformService),
}

declare const UpsideEngine: upsideEngine;
export default UpsideEngine;
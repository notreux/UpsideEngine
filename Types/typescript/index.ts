

export type BaseObject = {
Instance: Instance
Scene: string
InstanceType: string
Tags: 	{ 	},
new(self: BaseObject, parent: Scene): BaseObject
Set(self: BaseObject, properties: Dictionary<string, any>): null
AddTag(self: BaseObject, tag: string): null
HasTag(self: BaseObject, tag: string): boolean
RemoveTag(self: BaseObject, tag: string): null
}




export type Camera = {
Subject: Character
FollowSubject: boolean
new(self: Camera, scene: Scene): Camera
GetPosition(self: Camera): null
SetPosition(self: Camera, udim2: UDim2): null
SetSubject(self: Camera, subject: Character): null
LookTo(self: Camera, object: PhysicalObject): null
}




export type Connection = {
Active: boolean
new(self: Connection, eventId: number, event: Dictionary<string, table>): Connection
Wait(self: Connection, seconds: number?): thread?
Disconnect(self: Connection): null
}




export type EventEmitter = {
EventsStorage: 	{ 	},
On(self: EventEmitter, name: string, callback: () -> ()): Connection
Fire(self: EventEmitter, name: string, ...any): null
}




export type LightingEnvironment = {
AmbientColor: Color3
AmbientTransparency: number
UpdateFrequency: number
PixelIndex: number
Distance: number
InstanceType: string
Pixels: 	{ 	},
LightingIntensity: number
new(self: LightingEnvironment, parent: Frame): LightingEnvironment
DrawPixels(self: LightingEnvironment, settings: any): null
SetLightingIntensity(self: LightingEnvironment, value: number): null
GetLightingIntensity(self: LightingEnvironment): null
UpdateScreen(self: LightingEnvironment): null
}




export type ParticleEnvironment = {
}




export type Request = {
Content: 	{ 	},
ClientId: number
new(self: Request, clientId: number, content: Dictionary<string, any>): Request
Send(self: Request, content: Dictionary<string, any>): null
Approve(self: Request, clients: table): null
Accept(self: Request, ...any): BaseObject
GetClient(self: Request): null
}




export type SoundEnvironment = {
InstanceType: string
}




export type Character = {
Health: number
MaxHealth: number
WalkSpeed: number
JumpPower: number
UpdateHealth(self: Character, Health: number): null
Jump(self: Character, jumpPower: number?): null
MoveTo(self: Character, target: Vector2): null
}




export type Environment = {
Content: 	{ 	},
Count: number
InstanceType: string
new(self: Environment): Environment
Get(self: Environment, index: string): any
AddOne(self: Environment, value: any, index: string): null
RemoveOne(self: Environment, index: string): null
HasOne(self: Environment, index: string): boolean
Has(self: Environment, objects: Array<string>): (boolean, Dictionary<string, boolean>)
Add(self: Environment, objects: Dictionary<string, any>): null
Remove(self: Environment, objects: Array<string>): null
Update(self: Environment, objects: Dictionary<string, any>): null
FindByName(self: Environment, name: string): any
SetProperty(self: Environment, property: string, value: any): null
Run(self: Environment, method: string, ...any): null
}




export type Light = {
TrackCollisions: boolean
Color: Color3
Range: number
Brightness: number
Track: boolean
new(self: Light, scene: Scene): Light
}




export type Particle = {
Angle: Vector2
InstanceType: string
Subject: Character
MaxRate: number
Units: number
Properties: 	{
 Image: string,
	},
Goals: 	{
 Size: UDim2,
ImageTransparency: number,
	},
Info: TweenInfo
TrackLight: boolean
CanCollide: boolean
Enabled: boolean
LightBrightness: number
LightRange: number
Range: number
LifeTime: number
Clock: number
Rate: number
SetSubject(self: Particle, subject: Character): null
SetAngle(self: Particle, Angle: Vector2): null
SetMaxRate(self: Particle, maxRate: number): null
Emit(self: Particle, rate: number): null
}




export type PhysicalObject = {
InstanceType: string
ChromaticAberrationIntensity: number
ChromaticAberrationDistance: number
ChromaticAberrationPoint: Vector2
ChromaticAberration: 	{ 	},
Collisions: 	{ 	},
ChromaticAberrationConnection: boolean
CollisionBlacklist: 	{ 	},
Hitbox: 	{ 	},
Mass: number
HitboxScale: number
CollisionGroup: number
Anchored: boolean
CanCollide: boolean
IsGrounded: boolean
TrackCollisions: boolean
HitboxShape: string
Force: Vector2
Velocity: Vector2
new(self: PhysicalObject): PhysicalObject
SetHitboxShape(self: PhysicalObject, shape: string): null
Load(self: PhysicalObject, url: string): null
SetChromaticAberration(self: PhysicalObject, Intensity: number, Distance: number, Point: Vector2): null
}




export type Scene = {
Objects: 	{ 	},
InstanceType: string
SoundEnvironment: SoundEnvironment
ParticleEnvironment: ParticleEnvironment
LightingEnvironment: LightingEnvironment
new(self: Scene, parent: Instance): Scene
AddObject(self: Scene, object: BaseObject): null
RemoveObject(self: Scene, object: BaseObject): null
FindByName(self: Scene, name: string): BaseObject?
HasObject(self: Scene, object: BaseObject): boolean
GetTaggedObjects(self: Scene, tag: string): Array<string>
Raycast(self: Scene, info: Raycast2dParams): Raycast2dResult
}




export type Sound = {
InstanceType: string
Subject: Character
Range: number
MaxVolume: number
DistanceFading: boolean
SetSubject(self: Sound, subject: Character, useSceneSoundGroup: boolean?): null
}




export type Sprite = {
IsPlaying: boolean
Active: 	{
 Name: string,
CurrentFrame: Vector2,
SecondsPerFrame: number,
NextStepReady: boolean,
	},
SecondsPerFrame: number
Sprites: 	{ 	},
new(self: Sprite, parent: Scene, size: Vector2): Sprite
SetSpriteSheet(self: Sprite, name: string, url: string, frames: Vector2): null
SetSpriteList(self: Sprite, name: string, list: Array<string>): null
Play(self: Sprite, name: string, secondsPerFrame: number?): null
Stop(self: Sprite): null
}




export type CrossPlatformService = {
DefaultControllersEnabled: boolean
SideView: boolean
Character: Character
StickSensibility: number
Configs: 	{
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
	},
SetDeviceKey(self: CrossPlatformService, device: string, key: string, action: string): null
SetDeviceConfig(self: CrossPlatformService, device: string, controls: Dictionary<string, string?>): null
SetPlayerCharacter(self: CrossPlatformService, character: Character): null
}




export type NetworkingService = {
Players: 	{ 	},
DestroyObjectsOnLeave: boolean
Replicate(self: NetworkingService, object: BaseObject): null
ReplicateOnChange(self: NetworkingService, object: BaseObject): (Connection, Connection)
}




export type PluginSupportService = {
LoadPluginContent(self: PluginSupportService): null
SavePluginContent(self: PluginSupportService, content: {}): null
}




export type SceneManager = {
Scenes: 	{ 	},
ActiveScenes: 	{ 	},
Load(self: SceneManager, scene: Scene): null
Unload(self: SceneManager, scene: Scene): null
FindByName(self: SceneManager, name: string): Scene?
Get(self: SceneManager, Id: string): Scene
}




module.exports = {}
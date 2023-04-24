
declare function addReadonly(readonly: Dictionary<string, any>): ()

export type table = {}
export type Dictionary<k, v> = {}
export type Array<v> = {}
export type ChromaticAberrationConnection  = {}

export type Raycast2dResult = { 
    Object: PhysicalObject, 
    Position: UDim2, 
    Distance: Vector2, 
    Normal: UDim2 
}

export type Raycast2dParams = { 
    FilterType: string, 
    From: Vector2, 
    List: Array<BaseObject>, 
    To: any 
}
export type BaseClass = {
    Id: string,
    ClassName: string,
	Name: string,
    SetName: (name: string) -> (),
    IsA: (self: BaseClass, className: string) -> boolean,
    new: (...any) -> BaseClass,
    Clone: (...any) -> BaseClass,
    Extend: (self: BaseClass, className: string, classStructure: table) -> BaseClass,
    Destroy: () -> (),
}


--[[
	================================SELF-GENERATED================================
]]
export type BaseObject = EventEmitter & {
	Instance: Instance,
	Scene: string,
	InstanceType: string,
	Tags: {},
	new: (self: BaseObject, parent: Scene) -> BaseObject,
	Set: (self: BaseObject, properties: Dictionary<string, any>) -> nil,
	AddTag: (self: BaseObject, tag: string) -> nil,
	HasTag: (self: BaseObject, tag: string) -> boolean,
	RemoveTag: (self: BaseObject, tag: string) -> nil,
}

export type Camera = EventEmitter & {
	Subject: Character,
	FollowSubject: boolean,
	new: (self: Camera, scene: Scene) -> Camera,
	GetPosition: (self: Camera) -> nil,
	SetPosition: (self: Camera, udim2: UDim2) -> nil,
	SetSubject: (self: Camera, subject: Character) -> nil,
	LookTo: (self: Camera, object: PhysicalObject) -> nil,
}

export type Connection = BaseClass & {
	Active: boolean,
	new: (self: Connection, eventId: number, event: Dictionary<string, table>) -> Connection,
	Wait: (self: Connection, seconds: number?) -> thread?,
	Disconnect: (self: Connection) -> nil,
}

export type EventEmitter = BaseClass & {
	EventsStorage: {},
	On: (self: EventEmitter, name: string, callback: () -> ()) -> Connection,
	Fire: (self: EventEmitter, name: string, ...any) -> nil,
}

export type LightingEnvironment = Environment & {
	AmbientColor: Color3,
	AmbientTransparency: number,
	UpdateFrequency: number,
	PixelIndex: number,
	Distance: number,
	InstanceType: string,
	Pixels: {},
	LightingIntensity: number,
	new: (self: LightingEnvironment, parent: Frame) -> LightingEnvironment,
	DrawPixels: (self: LightingEnvironment, settings: any) -> nil,
	SetLightingIntensity: (self: LightingEnvironment, value: number) -> nil,
	GetLightingIntensity: (self: LightingEnvironment) -> nil,
	UpdateScreen: (self: LightingEnvironment) -> nil,
}

export type ParticleEnvironment = Environment & {}

export type Request = EventEmitter & {
	Content: {},
	ClientId: number,
	new: (self: Request, clientId: number, content: Dictionary<string, any>) -> Request,
	Send: (self: Request, content: Dictionary<string, any>) -> nil,
	Approve: (self: Request, clients: table) -> nil,
	Accept: (self: Request, ...any) -> BaseObject,
	GetClient: (self: Request) -> nil,
}

export type SoundEnvironment = Environment & {
	InstanceType: string,
}

export type Character = Sprite & {
	Health: number,
	MaxHealth: number,
	WalkSpeed: number,
	JumpPower: number,
	UpdateHealth: (self: Character, Health: number) -> nil,
	Jump: (self: Character, jumpPower: number?) -> nil,
	MoveTo: (self: Character, target: Vector2) -> nil,
}

export type Environment = BaseObject & {
	Content: {},
	Count: number,
	InstanceType: string,
	new: (self: Environment) -> Environment,
	Get: (self: Environment, index: string) -> any,
	AddOne: (self: Environment, value: any, index: string) -> nil,
	RemoveOne: (self: Environment, index: string) -> nil,
	HasOne: (self: Environment, index: string) -> boolean,
	Has: (self: Environment, objects: Array<string>) -> (boolean, Dictionary<string, boolean>),
	Add: (self: Environment, objects: Dictionary<string, any>) -> nil,
	Remove: (self: Environment, objects: Array<string>) -> nil,
	Update: (self: Environment, objects: Dictionary<string, any>) -> nil,
	FindByName: (self: Environment, name: string) -> any,
	SetProperty: (self: Environment, property: string, value: any) -> nil,
	Run: (self: Environment, method: string, ...any) -> nil,
}

export type Light = PhysicalObject & {
	TrackCollisions: boolean,
	Color: Color3,
	Range: number,
	Brightness: number,
	Track: boolean,
	new: (self: Light, scene: Scene) -> Light,
}

export type Particle = BaseObject & {
	Angle: Vector2,
	InstanceType: string,
	Subject: Character,
	MaxRate: number,
	Units: number,
	Properties: {
		Image: string,
	},
	Goals: {
		Size: UDim2,
		ImageTransparency: number,
	},
	Info: TweenInfo,
	TrackLight: boolean,
	CanCollide: boolean,
	Enabled: boolean,
	LightBrightness: number,
	LightRange: number,
	Range: number,
	LifeTime: number,
	Clock: number,
	Rate: number,
	SetSubject: (self: Particle, subject: Character) -> nil,
	SetAngle: (self: Particle, Angle: Vector2) -> nil,
	SetMaxRate: (self: Particle, maxRate: number) -> nil,
	Emit: (self: Particle, rate: number) -> nil,
}

export type PhysicalObject = BaseObject & {
	InstanceType: string,
	ChromaticAberrationIntensity: number,
	ChromaticAberrationDistance: number,
	ChromaticAberrationPoint: Vector2,
	ChromaticAberration: {},
	Collisions: {},
	ChromaticAberrationConnection: boolean,
	CollisionBlacklist: {},
	Hitbox: {},
	Mass: number,
	HitboxScale: number,
	CollisionGroup: number,
	Anchored: boolean,
	CanCollide: boolean,
	IsGrounded: boolean,
	TrackCollisions: boolean,
	HitboxShape: string,
	Force: Vector2,
	Velocity: Vector2,
	new: (self: PhysicalObject) -> PhysicalObject,
	SetHitboxShape: (self: PhysicalObject, shape: string) -> nil,
	Load: (self: PhysicalObject, url: string) -> nil,
	SetChromaticAberration: (self: PhysicalObject, Intensity: number, Distance: number, Point: Vector2) -> nil,
}

export type Scene = BaseObject & {
	Objects: {},
	InstanceType: string,
	SoundEnvironment: SoundEnvironment,
	ParticleEnvironment: ParticleEnvironment,
	LightingEnvironment: LightingEnvironment,
	new: (self: Scene, parent: Instance) -> Scene,
	AddObject: (self: Scene, object: BaseObject) -> nil,
	RemoveObject: (self: Scene, object: BaseObject) -> nil,
	FindByName: (self: Scene, name: string) -> BaseObject?,
	HasObject: (self: Scene, object: BaseObject) -> boolean,
	GetTaggedObjects: (self: Scene, tag: string) -> Array<string>,
	Raycast: (self: Scene, info: Raycast2dParams) -> Raycast2dResult,
}

export type Sound = BaseObject & {
	InstanceType: string,
	Subject: Character,
	Range: number,
	MaxVolume: number,
	DistanceFading: boolean,
	SetSubject: (self: Sound, subject: Character, useSceneSoundGroup: boolean?) -> nil,
}

export type Sprite = PhysicalObject & {
	IsPlaying: boolean,
	Active: {
		Name: string,
		CurrentFrame: Vector2,
		SecondsPerFrame: number,
		NextStepReady: boolean,
	},
	SecondsPerFrame: number,
	Sprites: {},
	new: (self: Sprite, parent: Scene, size: Vector2) -> Sprite,
	SetSpriteSheet: (self: Sprite, name: string, url: string, frames: Vector2) -> nil,
	SetSpriteList: (self: Sprite, name: string, list: Array<string>) -> nil,
	Play: (self: Sprite, name: string, secondsPerFrame: number?) -> nil,
	Stop: (self: Sprite) -> nil,
}

export type CrossPlatformService = EventEmitter & {
	DefaultControllersEnabled: boolean,
	SideView: boolean,
	Character: Character,
	StickSensibility: number,
	Configs: {
		Keyboard: {
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
		Gamepad: {
			ButtonA: string,
			Thumbstick1: {
				Up: string,
				Left: string,
				Down: string,
				Right: string,
			},
		},
		Mobile: {
			JumpButton: string,
			Thumbstick1: {
				Up: string,
				Left: string,
				Down: string,
				Right: string,
			},
		},
	},
	SetDeviceKey: (self: CrossPlatformService, device: string, key: string, action: string) -> nil,
	SetDeviceConfig: (self: CrossPlatformService, device: string, controls: Dictionary<string, string?>) -> nil,
	SetPlayerCharacter: (self: CrossPlatformService, character: Character) -> nil,
}

export type NetworkingService = EventEmitter & {
	Players: {},
	DestroyObjectsOnLeave: boolean,
	Replicate: (self: NetworkingService, object: BaseObject) -> nil,
	ReplicateOnChange: (self: NetworkingService, object: BaseObject) -> (Connection, Connection),
}

export type PluginSupportService = EventEmitter & {
	LoadPluginContent: (self: PluginSupportService) -> nil,
	SavePluginContent: (self: PluginSupportService, content: {}) -> nil,
}

export type SceneManager = EventEmitter & {
	Scenes: {},
	ActiveScenes: {},
	Load: (self: SceneManager, scene: Scene) -> nil,
	Unload: (self: SceneManager, scene: Scene) -> nil,
	FindByName: (self: SceneManager, name: string) -> Scene?,
	Get: (self: SceneManager, Id: string) -> Scene,
}
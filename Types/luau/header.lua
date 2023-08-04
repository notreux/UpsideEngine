-- THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.
export type table = {}
export type Dictionary<k, v> = {}
export type Array<v> = {}
export type ChromaticAberrationConnection = {}

export type BaseObjectParams = {
	InstanceType: string?,
	Parent: Scene,
}

export type SceneParams = {
	Parent: Instance,
}

export type SpriteParams = BaseObjectParams & {
	SpriteSize: Vector2,
}

export type ConnectionParams = {
	EventId: number,
	Event: {
		Functions: table,
		Threads: table,
	},
}

export type RequestParams = {
	ClientId: number?,
	Content: {
		className: string,
		id: string,
		name: string,
		properties: {
			instance: table,
			object: table,
		},
	}?,
}

export type Raycast2dResult = {
	Object: PhysicalObject,
	Position: UDim2,
	Distance: Vector2,
	Normal: UDim2,
}

export type Raycast2dParams = {
	FilterType: string,
	From: Vector2,
	List: Array<BaseObject>,
	To: any,
}

export type BaseClass = {
	Id: string,
	ClassName: string,
	Name: string,
	new: () -> BaseClass,
	SetName: (self: BaseClass, name: string) -> (),
	IsA: (self: BaseClass, className: string) -> boolean,
	Clone: (self: BaseClass, ...any) -> BaseClass,
	Destroy: (self: BaseClass) -> (),
}

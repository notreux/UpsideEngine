export type Scene = BaseObject & {
Objects: 	{ 	},
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


return {}
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


module.exports = {}
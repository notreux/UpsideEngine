export type upsideEngine = {
	Version: string,
	Workspace: {},
	new: ((name: "PhysicalObject", data: BaseObjectParams?) -> (data: BaseObjectParams) -> PhysicalObject)
		& ((name: "Sprite", data: SpriteParams?) -> (data: SpriteParams) -> Sprite)
		& ((name: "Sound", data: BaseObjectParams?) -> (data: BaseObjectParams) -> Sound)
		& ((name: "Environment", data: BaseObjectParams?) -> (data: BaseObjectParams) -> Environment)
		& ((name: "Light", data: BaseObjectParams?) -> (data: BaseObjectParams) -> Light)
		& ((name: "Character", data: SpriteParams?) -> (data: SpriteParams) -> Character)
		& ((name: "Scene", data: SceneParams?) -> (data: SceneParams) -> Scene)
		& ((name: "Particle", data: BaseObjectParams?) -> (data: BaseObjectParams) -> Particle),

	Extend: ((name: "PhysicalObject", classData: ClassData) -> (classData: ClassData) -> PhysicalObject)
		& ((name: "Sprite", classData: ClassData) -> (classData: ClassData) -> Sprite)
		& ((name: "Sound", classData: ClassData) -> (classData: ClassData) -> Sound)
		& ((name: "Environment", classData: ClassData) -> (classData: ClassData) -> Environment)
		& ((name: "Light", classData: ClassData) -> (classData: ClassData) -> Light)
		& ((name: "Character", classData: ClassData) -> (classData: ClassData) -> Character)
		& ((name: "Scene", classData: ClassData) -> (classData: ClassData) -> Scene)
		& ((name: "Particle", classData: ClassData) -> (classData: ClassData) -> Particle),

	GetService: ((name: "SceneManager") -> SceneManager)
		& ((name: "PluginSupportService") -> PluginSupportService)
		& ((name: "NetworkingService") -> NetworkingService)
		& ((name: "CrossPlatformService") -> CrossPlatformService),
}

return {}

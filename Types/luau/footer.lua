export type upsideEngine = {
	Version: string,
	Workspace: {},
	new: ((name: "PhysicalObject") -> (data: BaseObjectParams) -> PhysicalObject)
		& ((name: "Sprite") -> (data: SpriteParams) -> Sprite)
		& ((name: "Sound") -> (data: BaseObjectParams) -> Sound)
		& ((name: "Environment") -> (data: BaseObjectParams) -> Environment)
		& ((name: "Light") -> (data: BaseObjectParams) -> Light)
		& ((name: "Character") -> (data: SpriteParams) -> Character)
		& ((name: "Scene") -> (data: SceneParams) -> Scene)
		& ((name: "Particle") -> (data: BaseObjectParams) -> Particle),

	Extend: ((name: "PhysicalObject") -> (classData: ClassData) -> PhysicalObject)
		& ((name: "Sprite") -> (classData: ClassData) -> Sprite)
		& ((name: "Sound") -> (classData: ClassData) -> Sound)
		& ((name: "Environment") -> (classData: ClassData) -> Environment)
		& ((name: "Light") -> (classData: ClassData) -> Light)
		& ((name: "Character") -> (classData: ClassData) -> Character)
		& ((name: "Scene") -> (classData: ClassData) -> Scene)
		& ((name: "Particle") -> (classData: ClassData) -> Particle),

	GetService: ((name: "SceneManager") -> SceneManager)
		& ((name: "PluginSupportService") -> PluginSupportService)
		& ((name: "NetworkingService") -> NetworkingService)
		& ((name: "CrossPlatformService") -> CrossPlatformService),
}

return {}

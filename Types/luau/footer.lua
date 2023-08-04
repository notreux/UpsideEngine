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

	GetService: ((name: "SceneManager") -> SceneManager)
		& ((name: "PluginSupportService") -> PluginSupportService)
		& ((name: "NetworkingService") -> NetworkingService)
		& ((name: "CrossPlatformService") -> CrossPlatformService),
}

return {}

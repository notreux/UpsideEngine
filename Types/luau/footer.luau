export type upsideEngine = {
	Version: string,
	Workspace: {},
	new: ((name: "PhysicalObject") -> PhysicalObject)
		& ((name: "Sprite") -> Sprite)
		& ((name: "Sound") -> Sound)
		& ((name: "Environment") -> Environment)
		& ((name: "Light") -> Light)
		& ((name: "Character") -> Character)
		& ((name: "Scene") -> Scene)
		& ((name: "Particle") -> Particle),

	GetService: ((name: "SceneManager") -> SceneManager)
		& ((name: "PluginSupportService") -> PluginSupportService)
		& ((name: "NetworkingService") -> NetworkingService)
		& ((name: "CrossPlatformService") -> CrossPlatformService),
}

return {}

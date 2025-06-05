export type upsideEngine = {
	Version: string,
	Workspace: {},
	new: ((name: "PhysicalObject") -> PhysicalObject)
		& ((name: "StaticObject") -> StaticObject)
		& ((name: "Fluid") -> Fluid)
		& ((name: "Parallax") -> Parallax)
		& ((name: "Sprite") -> Sprite)
		& ((name: "Sound") -> Sound)
		& ((name: "Environment") -> Environment)
		& ((name: "Light") -> Light)
		& ((name: "Character") -> Character)
		& ((name: "Scene") -> Scene)
		& ((name: "Particle") -> Particle)
		& ((name: "Shader") -> Shader)
		& ((name: "TextTag") -> TextTag)
		& ((name: "ReactiveLabel") -> ReactiveLabel)
		& ((name: "ProximityPrompt2D") -> ProximityPrompt2D),

	GetService: ((name: "SceneManager") -> SceneManager)
		& ((name: "PluginSupportService") -> PluginSupportService)
		& ((name: "NetworkingService") -> NetworkingService)
		& ((name: "TextTagService") -> TextTagService)
		& ((name: "CrossPlatformService") -> CrossPlatformService),
}

return {}

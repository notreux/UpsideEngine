interface upsideEngine {
	Version: string;
	Workspace: {};
	new: ((name: "PhysicalObject") => PhysicalObject)
		& ((name: "Sprite") => Sprite)
		& ((name: "Sound") => Sound)
		& ((name: "Environment") => Environment)
		& ((name: "Light") => Light)
		& ((name: "Character") => Character)
		& ((name: "Scene") => Scene)
		& ((name: "Particle") => Particle),

	Extend: ((name: "PhysicalObject") => PhysicalObject)
		& ((name: "Sprite") => Sprite)
		& ((name: "Sound") => Sound)
		& ((name: "Environment") => Environment)
		& ((name: "Light") => Light)
		& ((name: "Character") => Character)
		& ((name: "Scene") => Scene)
		& ((name: "Particle") => Particle)

	GetService: ((name: "SceneManager") => SceneManager)
		& ((name: "PluginSupportService") => PluginSupportService)
		& ((name: "NetworkingService") => NetworkingService)
		& ((name: "CrossPlatformService") => CrossPlatformService),
}

declare const UpsideEngine: upsideEngine;
export default UpsideEngine;
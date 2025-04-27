interface upsideEngine {
	Version: string;
	Workspace: {};
	new: ((name: "PhysicalObject") => PhysicalObject)
		& ((name: "Sprite") => Sprite)
		& ((name: "StaticObject") => StaticObject)
		& ((name: "Fluid") => Fluid)
		& ((name: "Parallax") => Parallax)
		& ((name: "Sound") => Sound)
		& ((name: "Environment") => Environment)
		& ((name: "Light") => Light)
		& ((name: "Character") => Character)
		& ((name: "Scene") => Scene)
		& ((name: "Particle") => Particle)
		& ((name: "Shader") => Shader)
		& ((name: "TextTag") => TextTag)
		& ((name: "ReactiveLabel") => ReactiveLabel),


	GetService: ((name: "SceneManager") => SceneManager)
		& ((name: "PluginSupportService") => PluginSupportService)
		& ((name: "NetworkingService") => NetworkingService)
		& ((name: "CrossPlatformService") => CrossPlatformService),
}

declare const UpsideEngine: upsideEngine;
export default UpsideEngine;
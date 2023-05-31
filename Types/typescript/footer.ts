interface upsideEngine {
	Version: string;
	Workspace: {};
	Create: ((name: "PhysicalObject", ...any) => PhysicalObject)
		& ((name: "Sprite", ...any) => Sprite)
		& ((name: "Sound", ...any) => Sound)
		& ((name: "Environment", ...any) => Environment)
		& ((name: "Light", ...any) => Light)
		& ((name: "Character", ...any) => Character)
		& ((name: "Scene", ...any) => Scene)
		& ((name: "Particle", ...any) => Particle)

	Extend: ((name: "PhysicalObject", classData: ClassData) => PhysicalObject)
		& ((name: "Sprite", classData: ClassData) => Sprite)
		& ((name: "Sound", classData: ClassData) => Sound)
		& ((name: "Environment", classData: ClassData) => Environment)
		& ((name: "Light", classData: ClassData) => Light)
		& ((name: "Character", classData: ClassData) => Character)
		& ((name: "Scene", classData: ClassData) => Scene)
		& ((name: "Particle", classData: ClassData) => Particle)

	GetService: ((name: "SceneManager") => SceneManager)
		& ((name: "PluginSupportService") => PluginSupportService)
		& ((name: "NetworkingService") => NetworkingService)
		& ((name: "CrossPlatformService") => CrossPlatformService),
}

declare const UpsideEngine: upsideEngine;
export default UpsideEngine;
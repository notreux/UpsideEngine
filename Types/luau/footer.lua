export type upsideEngine = {
	Version: string,
	Workspace: {},
	Create: ((self: upsideEngine, name: "PhysicalObject", ...any) -> PhysicalObject)
		& ((self: upsideEngine, name: "Sprite", ...any) -> Sprite)
		& ((self: upsideEngine, name: "Sound", ...any) -> Sound)
		& ((self: upsideEngine, name: "Environment", ...any) -> Environment)
		& ((self: upsideEngine, name: "Light", ...any) -> Light)
		& ((self: upsideEngine, name: "Character", ...any) -> Character)
		& ((self: upsideEngine, name: "Scene", ...any) -> Scene)
		& ((self: upsideEngine, name: "Particle", ...any) -> Particle)
		& ((self: upsideEngine, name: "Scene", ...any) -> Scene),

	Extend: ((self: upsideEngine, name: "PhysicalObject", classData: ClassData) -> PhysicalObject)
		& ((self: upsideEngine, name: "Sprite", classData: ClassData) -> Sprite)
		& ((self: upsideEngine, name: "Sound", classData: ClassData) -> Sound)
		& ((self: upsideEngine, name: "Environment", classData: ClassData) -> Environment)
		& ((self: upsideEngine, name: "Light", classData: ClassData) -> Light)
		& ((self: upsideEngine, name: "Character", classData: ClassData) -> Character)
		& ((self: upsideEngine, name: "Scene", classData: ClassData) -> Scene)
		& ((self: upsideEngine, name: "Particle", classData: ClassData) -> Particle)
		& ((self: upsideEngine, name: "Scene", classData: ClassData) -> Scene),

	GetService: ((self: upsideEngine, name: "SceneManager") -> SceneManager)
		& ((self: upsideEngine, name: "PluginSupportService") -> PluginSupportService)
		& ((self: upsideEngine, name: "NetworkingService") -> NetworkingService)
		& ((self: upsideEngine, name: "CrossPlatformService") -> CrossPlatformService),
}

return {}

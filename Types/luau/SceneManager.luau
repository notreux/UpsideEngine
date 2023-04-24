export type SceneManager = EventEmitter & {
Scenes: 	{ 	},
ActiveScenes: 	{ 	},
Load: (self: SceneManager, scene: Scene) -> nil,
Unload: (self: SceneManager, scene: Scene) -> nil,
FindByName: (self: SceneManager, name: string) -> Scene?,
Get: (self: SceneManager, Id: string) -> Scene,
}


return {}
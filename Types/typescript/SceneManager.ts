export type SceneManager = {
Scenes: 	{ 	},
ActiveScenes: 	{ 	},
Load(self: SceneManager, scene: Scene): null
Unload(self: SceneManager, scene: Scene): null
FindByName(self: SceneManager, name: string): Scene?
Get(self: SceneManager, Id: string): Scene
}


module.exports = {}
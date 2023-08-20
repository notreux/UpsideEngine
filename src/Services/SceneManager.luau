local upsideEngine = script.Parent.Parent
local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)

local sceneManager = {}
sceneManager.__index = sceneManager

function sceneManager.new()
	local self = eventEmitter.new()
	self.Scenes = {}
	self.ActiveScenes = {}

	return setmetatable(self, sceneManager)
end

--[[={
	@desc Finds a scene by the name
	@link void.link
}=]]

function sceneManager:FindByName(name: string): Scene?
	for _, scene in self.Scenes do
		if scene.Name == name then
			return scene
		end
	end

	return
end

--[[={
	@desc Returns the scene with the specified Id
	@link Scene.md
}=]]

function sceneManager:Get(Id: string): Scene
	return self.Scenes[Id]
end

--[[={
	@desc This class save and build the engine data
	@about
		@Scenes	This dictionary stores all the scenes
		@ActiveScenes This dictionary stores all the active scenes
	@events
		@SceneLoaded Params -> [Scene](Scene.md) 
		Fired when a scene is loaded
		@SceneUnloaded Params -> [Scene](Scene.md) 
		Fired when a scene is unloaded
}=]]

return setmetatable(sceneManager, eventEmitter).new()

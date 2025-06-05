local CrossPlatformService = require(script.Parent.Parent.Services.CrossPlatformService)
local SceneManager = require(script.Parent.Parent.Services.SceneManager)

local function emitTriggerEvent(input, eventName)
	for _, scene in SceneManager.ActiveScenes do
		for _, object in scene.Objects do
			if not object:IsA("ProximityPrompt2D") or not object.Enabled then
				continue
			end

			if input.Action == object.ActionName and object.IsClosest then
				object:Fire(eventName)
			end
		end
	end
end

CrossPlatformService:On("InputBegin", function(input)
	emitTriggerEvent(input, "Triggered")
end)

CrossPlatformService:On("InputEnd", function(input)
	emitTriggerEvent(input, "TriggerEnded")
end)

return {}

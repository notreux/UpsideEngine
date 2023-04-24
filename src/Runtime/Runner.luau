local upsideEngine = script.Parent.Parent
local stepFolder = script:FindFirstAncestorOfClass("Folder").EveryStep

local runService = game:GetService("RunService")
local sceneManager = require(upsideEngine.Services.SceneManager)

local trackers = {}
local childs = stepFolder:GetChildren()

for _, tracker in ipairs(childs) do
	if not tracker.Name:match(".spec") then
		table.insert(trackers, require(tracker))
	end
end

local function everyStep(deltaTime)
	for _, scene in pairs(sceneManager.ActiveScenes) do
		for _, tracker in ipairs(trackers) do
			tracker(scene, deltaTime)
		end
	end
end

if runService:IsRunning() then
	runService.Heartbeat:Connect(everyStep)
end

return {}

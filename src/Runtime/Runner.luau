--!native
local upsideEngine = script.Parent.Parent
local stepFolder = script:FindFirstAncestorOfClass("Folder").EveryStep

local runService = game:GetService("RunService")
local sceneManager = require(upsideEngine.Services.SceneManager)

local childs = stepFolder:GetChildren()
local trackers = {}

for _, tracker in childs do
	if not tracker.Name:match(".spec") then
		trackers[tracker.Name] = require(tracker)
	end
end

local t1 = os.clock()
local FIXED_DELTA_TIME = 1 / 250

local function everyStep(target)
	local now = os.clock()
	local deltaTime = now - t1

	local accumulator = deltaTime
	t1 = now

	while accumulator >= FIXED_DELTA_TIME do
		for _, scene in sceneManager.ActiveScenes do
			for _, tracker in target do
				tracker(scene, FIXED_DELTA_TIME)
			end
		end

		accumulator -= FIXED_DELTA_TIME
	end
end

if runService:IsRunning() then
	local target = if runService:IsServer() --
		then { trackers.Physics }
		else trackers

	runService.Heartbeat:Connect(function()
		everyStep(target)
	end)
end

return {}

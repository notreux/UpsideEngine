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
local MAX_STEPS = 10

if runService:IsRunning() then
	local fixedNames = { Physics = true, CameraTracker = true, ParallaxTracker = true }
	local fixedTarget = {}
	local frameTarget = {}

	if runService:IsServer() then
		table.insert(fixedTarget, trackers.Physics)
	else
		for name, tracker in trackers do
			if fixedNames[name] then
				table.insert(fixedTarget, tracker)
			else
				table.insert(frameTarget, tracker)
			end
		end
	end

	runService.Heartbeat:Connect(function()
		local now = os.clock()
		local deltaTime = now - t1
		t1 = now

		local accumulator = math.min(deltaTime, FIXED_DELTA_TIME * MAX_STEPS)

		while accumulator >= FIXED_DELTA_TIME do
			for _, scene in sceneManager.ActiveScenes do
				for _, tracker in fixedTarget do
					tracker(scene, FIXED_DELTA_TIME)
				end
			end
			accumulator -= FIXED_DELTA_TIME
		end

		for _, scene in sceneManager.ActiveScenes do
			for _, tracker in frameTarget do
				tracker(scene, deltaTime)
			end
		end
	end)
end

return {}

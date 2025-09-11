--!native
local upsideEngine = script.Parent.Parent
local stepFolder = script:FindFirstAncestorOfClass("Folder").EveryStep

local runService = game:GetService("RunService")
local sceneManager = require(upsideEngine.Services.SceneManager)

local childs = stepFolder:GetChildren()
local trackers = {}

for _, tracker in childs do
	if not tracker.Name:match(".spec") then
		table.insert(trackers, require(tracker))
	end
end

local t1 = os.clock()
local function everyStep()
	local fixedDeltaTime = 1 / 250
	local accumulator = 0

	local now = os.clock()
	local deltaTime = now - t1
	accumulator += deltaTime
	t1 = now

	while accumulator >= fixedDeltaTime do
		for _, scene in sceneManager.ActiveScenes do
			for _, tracker in trackers do
				tracker(scene, fixedDeltaTime)
			end
		end

		accumulator -= fixedDeltaTime
	end
end

if runService:IsRunning() and runService:IsClient() then
	runService.Heartbeat:Connect(everyStep)
end

return {}

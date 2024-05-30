--!native
local upsideEngine = script.Parent.Parent
local stepFolder = script:FindFirstAncestorOfClass("Folder").EveryStep

local runService = game:GetService("RunService")
local sceneManager = require(upsideEngine.Services.SceneManager)

local childs = stepFolder:GetChildren()
local trackers = {}

local frames = {}
local init = os.clock()

for _, tracker in ipairs(childs) do
	if not tracker.Name:match(".spec") then
		table.insert(trackers, require(tracker))
	end
end

local function everyStep()
	local now = os.clock()

	local FPSTarget = 0
	local timeCounter = 0

	for i, sec in frames do
		if timeCounter >= 1 then
			frames[i] = nil
			continue
		end

		local prev = frames[i + 1]
		local dif = if prev then sec - prev else frames[1] - sec
		timeCounter += dif
		FPSTarget += 1
	end

	local deltaTime = 1 / FPSTarget
	table.insert(frames, 1, now)

	if now - init < 1 then
		return
	end

	for _, scene in pairs(sceneManager.ActiveScenes) do
		local lighting = scene.LightingEnvironment
		local objects = scene.Objects
		local shadable = {}

		for _, object in objects do
			if not object.Shader.Enabled then
				continue
			end

			shadable[object.Id] = object
		end

		lighting.__actrees:SetVariable("lights", lighting.Content)
		objects.__actor:SetVariable("shadable", shadable)

		for _, tracker in ipairs(trackers) do
			tracker(scene, deltaTime)
		end
	end
end

if runService:IsRunning() and runService:IsClient() then
	runService.Heartbeat:Connect(everyStep)
end

return {}

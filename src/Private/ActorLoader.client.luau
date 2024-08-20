local runService = game:GetService("RunService")
local actor = script:GetActor()

if runService:IsStudio() or not actor then
	return
end

local data = {}
local running = {}

local module = nil
local ready = script:WaitForChild("ready")

actor:BindToMessage("init", function(moduleScript)
	module = require(moduleScript)
end)

actor:BindToMessage("setVariable", function(name, value)
	data[name] = module.onSetData(data, name, value)
end)

actor:BindToMessage("updateVariable", function(name)
	data[name] = module.onSetData(data, name, data[name])
end)

actor:BindToMessage("execute", function(name)
	local func = module[name]
	func(data)
end)

actor:BindToMessage("executeEveryStep", function(name)
	if running[name] then
		return
	end

	local func = module[name]
	running[name] = true
	runService.Heartbeat:ConnectParallel(function(deltaTime)
		func(data, deltaTime)
	end)
end)

ready:Fire()

local RunService = game:GetService("RunService")
local actor = script:GetActor()

if not RunService:IsRunning() or not actor then
	return
end

local data = {}
local running = {}
local tasks = {}

local module = nil
local runMode = "Default"
local ready = script:WaitForChild("ready")

local function addTask(f)
	return function(...)
		if runMode == "Default" then
			f(...)
			return
		end

		local args = { ... }
		table.insert(tasks, function()
			f(unpack(args))
		end)
	end
end

actor:BindToMessage("setRunMode", function(mode)
	runMode = mode
end)

actor:BindToMessage(
	"init",
	addTask(function(moduleScript)
		module = require(moduleScript)
	end)
)

actor:BindToMessage(
	"setVariable",
	addTask(function(name, value)
		data[name] = module.onSetData(data, name, value)
	end)
)

actor:BindToMessage(
	"updateVariable",
	addTask(function(name)
		data[name] = module.onSetData(data, name, data[name])
	end)
)

actor:BindToMessage(
	"execute",
	addTask(function(name)
		local func = module[name]
		func(data)
	end)
)

actor:BindToMessage(
	"executeEveryStep",
	addTask(function(name)
		if running[name] then
			return
		end

		local func = module[name]
		running[name] = true
		RunService.Heartbeat:ConnectParallel(function(deltaTime)
			func(data, deltaTime)
		end)
	end)
)

ready:Fire()

while task.wait() do
	for index, run in tasks do
		table.remove(tasks, index)
		local sucess, err = pcall(run)
		if not sucess then
			warn(err)
		end
	end
end

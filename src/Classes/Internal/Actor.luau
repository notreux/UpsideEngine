local runService = game:GetService("RunService")
local private = script.Parent.Parent.Parent.Private
local player = game:GetService("Players").LocalPlayer

local actorLoader = private:WaitForChild("ActorLoader")
local util = require(private.Util)

local copyTable = util.CopyTable
local isEqual = util.IsEqual

local isClient = runService:IsClient()
local actor = {}
actor.__index = actor

function actor.new(module: ModuleScript)
	local instance = Instance.new("Actor")
	instance.Parent = if isClient then player:FindFirstChild("PlayerScripts") else workspace

	local loader = actorLoader:Clone()
	loader.Parent = instance

	local ready = Instance.new("BindableEvent")
	ready.Name = "ready"
	ready.Parent = loader

	if not runService:IsRunMode() then
		ready.Event:Wait()
		ready:Destroy()
	end

	instance:SendMessage("init", module)

	return setmetatable({
		instance = instance,
		__cache = {},
	}, actor)
end

function actor:SetVariable(name: string, value: any, ignoreCache: boolean)
	if not ignoreCache then
		local equal = isEqual(self.__cache[name], value)
		if equal then
			self:UpdateVariable(name)
			return
		end
	end

	self.__cache[name] = if typeof(value) == "table" then copyTable(value) else value
	self.instance:SendMessage("setVariable", name, value)
end

function actor:SetRunMode(name)
	self.instance:SendMessage("setRunMode", name)
end

function actor:UpdateVariable(name)
	self.instance:SendMessage("updateVariable", name)
end

function actor:Execute(name: string)
	self.instance:SendMessage("execute", name)
end

function actor:ExecuteEveryStep(name: string)
	self.instance:SendMessage("executeEveryStep", name)
end

return actor

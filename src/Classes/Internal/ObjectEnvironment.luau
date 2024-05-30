local upsideEngine = script.Parent.Parent.Parent
local shadingSystem = script.Parent.Parent.Parent.Systems.Shading
local Actor = require(script.Parent.Actor)
local environment = require(upsideEngine.Classes.Public.Environment)

local objectEnvironment = {}
objectEnvironment.__index = objectEnvironment
objectEnvironment.__iter = environment.__iter

function objectEnvironment.new(): ObjectEnvironment
	local self = environment.new()
	self:SetClassName(script.Name)
	self.__actor = Actor.new(shadingSystem)
	self.__actor:SetVariable("shadable", {})
	self.__actor:ExecuteEveryStep("draw")

	return setmetatable(self, objectEnvironment)
end

return setmetatable(objectEnvironment, environment)

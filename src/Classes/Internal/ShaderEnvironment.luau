local upsideEngine = script.Parent.Parent.Parent
local shadingSystem = script.Parent.Parent.Parent.Systems.Shading
local Actor = require(script.Parent.Actor)
local environment = require(upsideEngine.Classes.Public.Environment)

local shaderEnvironment = {}
shaderEnvironment.__index = shaderEnvironment
shaderEnvironment.__iter = environment.__iter

function shaderEnvironment.new(): ObjectEnvironment
	local self = environment.new()
	self:SetClassName(script.Name)
	self.__actor = Actor.new(shadingSystem)
	self.__actor:SetVariable("shadable", {})
	self.__actor:ExecuteEveryStep("draw")

	return setmetatable(self, shaderEnvironment)
end

return setmetatable(shaderEnvironment, environment)

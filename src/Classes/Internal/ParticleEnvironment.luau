local upsideEngine = script.Parent.Parent.Parent
local environment = require(upsideEngine.Classes.Public.Environment)

local particleEnvironment = {}
particleEnvironment.__index = particleEnvironment

function particleEnvironment.new(): ParticleEnvironment
	local self = environment.new()
	self:SetClassName(script.Name)
	
	return setmetatable(self, particleEnvironment)
end

return setmetatable(particleEnvironment, environment)

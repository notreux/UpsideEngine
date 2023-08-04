local upsideEngine = script.Parent.Parent.Parent
local environment = require(upsideEngine.Classes.Public.Environment)

local particleEnvironment = {}
particleEnvironment.__index = particleEnvironment

function particleEnvironment.new(data: BaseObjectParams): ParticleEnvironment
	local self = environment.new({
		Parent = data.Parent,
	})

	self:SetClassName(script.Name)
	return setmetatable(self, particleEnvironment)
end

return setmetatable(particleEnvironment, environment)

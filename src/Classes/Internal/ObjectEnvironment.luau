local upsideEngine = script.Parent.Parent.Parent
local environment = require(upsideEngine.Classes.Public.Environment)

local objectEnvironment = {}
objectEnvironment.__index = objectEnvironment
objectEnvironment.__iter = environment.__iter

function objectEnvironment.new(): ObjectEnvironment
	local self = environment.new()
	self:SetClassName(script.Name)

	return setmetatable(self, objectEnvironment)
end

return setmetatable(objectEnvironment, environment)

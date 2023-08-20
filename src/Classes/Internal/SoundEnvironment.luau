local upsideEngine = script.Parent.Parent.Parent
local environment = require(upsideEngine.Classes.Public.Environment)
local soundEnvironment = {}
soundEnvironment.__index = soundEnvironment

--[[={
	@link SoundEnvironment.md
}=]]

function soundEnvironment.new(): SoundEnvironment
	local self = environment.new()
	self.Instance.Parent = game.SoundService
	self:SetClassName(script.Name)

	return setmetatable(self, soundEnvironment)
end

return setmetatable(soundEnvironment, environment)

local upsideEngine = script.Parent.Parent.Parent
local Environment = require(upsideEngine.Classes.Public.Environment)
local constructor = {}

--[[={
	@link SoundEnvironment.md
}=]]

function constructor:ZSoundEnvironment()
	self.Instance.Parent = game.SoundService
	return
end

return Environment:Extend(script.Name, {
	readonly = { InstanceType = "SoundGroup" },
	constructors = constructor,
})

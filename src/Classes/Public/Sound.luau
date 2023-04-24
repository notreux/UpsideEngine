local upsideEngine = script.Parent.Parent.Parent
local restricted = require(upsideEngine.AppData.Data).restricted

local baseObject = require(upsideEngine.Classes.Internal.BaseObject)
local character = require(upsideEngine.Classes.Public.Character)

local methods = {}
local function getSoundEnvironment(scene: string): SoundEnvironment
	return restricted[scene].readonly.SoundEnvironment
end

--[[={
	@desc Sets the provided character as subject, if is provided a sound group, this will be the new sound group of the sound
	@link void.link
}=]]

function methods:SetSubject(subject: Character, useSceneSoundGroup: boolean?)
	assert(restricted[subject.Scene] ~= nil, "The subject must be in a scene!")

	local sceneId = self.Subject.Scene or nil
	if self.Subject and restricted[sceneId] then
		local SoundEnvironment = getSoundEnvironment(sceneId)
		SoundEnvironment.Content[self.Id] = nil
	end

	local SoundEnvironment = getSoundEnvironment(subject.Scene)
	SoundEnvironment.Content[self.Id] = self

	self.Subject = subject
	if useSceneSoundGroup then
		self.Instance.SoundGroup = SoundEnvironment.Instance
	end
end

--[[={
	@desc This class is used to play sounds
	@about
		@Subject This table stores all the objects in the scene
		@Range This is the SoundEnvironment of the scene
		@MaxVolume This is the ParticleEnvironment of the scene
		@DistanceFading The volume will depend on the player distance
}=]]

return baseObject:Extend(script.Name, {
	methods = methods,
	readonly = {
		InstanceType = "Sound",
		Subject = character:new(),
	},

	rules = {
		Range = 1000,
		MaxVolume = 1,
		DistanceFading = true,
	},
})

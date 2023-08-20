local upsideEngine = script.Parent.Parent.Parent
local objects = require(upsideEngine.AppData.Data).objects

local character = require(script.Parent.Character)
local baseObject = require(upsideEngine.Classes.Internal.BaseObject)
local sound = {}
sound.__index = sound

local function getSoundEnvironment(scene: string): SoundEnvironment
	return objects[scene].SoundEnvironment
end

function sound.new(): Sound
	local self = baseObject.new("Sound")
	self:SetClassName(script.Name)
	self.Range = 1000
	self.MaxVolume = 1
	self.DistanceFading = true
	self.Subject = character.new()

	return setmetatable(self, sound)
end

--[[={
	@desc Sets the provided character as subject, if is provided a sound group, this will be the new sound group of the sound
	@link void.link
}=]]

function sound:SetSubject(subject: Character, useSceneSoundGroup: boolean?)
	assert(objects[subject.Scene] ~= nil, "The subject must be in a scene!")

	local sceneId = self.Subject.Scene or nil
	if self.Subject and objects[sceneId] then
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

return setmetatable(sound, baseObject)

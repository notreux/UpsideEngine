local upsideEngine = script.Parent.Parent.Parent
local objects = require(upsideEngine.AppData.Data).objects

local character = require(script.Parent.Character)
local baseObject = require(upsideEngine.Classes.Internal.BaseObject)
local sound = {}
sound.__index = sound

local function getSoundEnvironment(scene: string): SoundEnvironment
	return objects[scene].SoundEnvironment
end

local function disconnectSubject(self)
	if self.SubjectDestroyConnection then
		self.SubjectDestroyConnection:Disconnect()
		self.SubjectDestroyConnection = nil
	end
end

local function removeFromSoundEnvironment(self)
	local sceneId = self.Subject and self.Subject.Scene or nil
	if self.Subject and objects[sceneId] then
		local soundEnvironment = getSoundEnvironment(sceneId)
		soundEnvironment.Content[self.Id] = nil
	end
end

local function bindSubject(self, subject)
	disconnectSubject(self)
	self.Subject = subject

	if not subject then
		return
	end

	self.SubjectDestroyConnection = subject:On("Destroy", function()
		if self.Subject ~= subject then
			return
		end

		removeFromSoundEnvironment(self)
		disconnectSubject(self)
		self.Subject = nil
	end)
end

function sound.new(): Sound
	local self = baseObject.new("Sound")
	self:SetClassName(script.Name)
	self.Range = 1000
	self.MaxVolume = 1
	self.DistanceFading = true
	self.SubjectDestroyConnection = nil
	bindSubject(self, character.new())

	return setmetatable(self, sound)
end

--[[={
	@desc Sets the provided character as subject, if is provided a sound group, this will be the new sound group of the sound
	@link void.link
}=]]

function sound:SetSubject(subject: Character, useSceneSoundGroup: boolean?)
	assert(objects[subject.Scene] ~= nil, "The subject must be in a scene!")

	removeFromSoundEnvironment(self)

	local SoundEnvironment = getSoundEnvironment(subject.Scene)
	SoundEnvironment.Content[self.Id] = self

	bindSubject(self, subject)
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

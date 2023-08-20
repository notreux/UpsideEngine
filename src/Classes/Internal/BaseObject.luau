local eventEmitter = require(script.Parent.EventEmitter)
local classEnvironments = {
	Sound = "SoundEnvironment",
	Light = "LightingEnvironment",
	Particle = "ParticleEnvironment",
}

local baseObject = {}
baseObject.__index = baseObject
--[[={
	@link BaseObject.md
}=]]

function baseObject.new(instanceType: string?): BaseObject
	local self = eventEmitter.new()
	self:SetClassName(script.Name)
	self.Instance = Instance.new(instanceType or "ImageLabel")
	self.Scene = "SceneId"
	self.Tags = {}

	return setmetatable(self, baseObject)
end

--[[={
	@desc Sets the object scene
	@link void.link
}=]]

function baseObject:SetScene(scene: Scene)
	local environment = classEnvironments[self.ClassName]
	scene.Objects[self.Id] = self

	self.Scene = scene.Id
	self.Instance.Parent = scene.Instance

	if environment then
		environment = (scene :: table)[environment]
		environment:AddOne(self, self.Id)
	end
end

--[[={
	@desc Adds a tag to the object
	@link void.link
}=]]

function baseObject:AddTag(tag: string)
	self.Tags[tag] = true
end

--[[={
	@desc Checks if the object contain the specified tag
	@link boolean.link
}=]]

function baseObject:HasTag(tag: string): boolean
	return self.Tags[tag]
end

--[[={
	@desc Removes a tag from the object
	@link void.link
}=]]

function baseObject:RemoveTag(tag: string)
	self.Tags[tag] = nil
end

--[[={
	@desc This class is the base class of the majority of classes
	@about
		@Instance The object instance
		@Scene The object scene ID
		@InstanceType The class name of the object instance
		@Tags This table stores all the tags of the object
}=]]

return setmetatable(baseObject, eventEmitter)

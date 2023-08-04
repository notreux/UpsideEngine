local eventEmitter = require(script.Parent.EventEmitter)
local baseObject = {}
baseObject.__index = baseObject
--[[={
	@link BaseObject.md
}=]]

function baseObject.new(data: BaseObjectParams): BaseObject
	local parent = data.Parent
	local parentType = typeof(parent)

	local parentInstance = parentType == "Instance" and parent or nil
	local self = eventEmitter.new()

	self:SetClassName(script.Name)
	self.Instance = Instance.new(data.InstanceType or "ImageLabel")
	self.ClassName = script.Name
	self.Scene = "SceneId"
	self.Tags = {}

	if parentInstance then
		self.Instance.Parent = parentInstance
	elseif parent and parent.ClassName == "Scene" then
		parent:AddObject(self)
	end

	return setmetatable(self, baseObject)
end

--[[={
	@desc Sets the properties of the object instance
	@link void.link
}=]]

function baseObject:Set(properties: Dictionary<string, any>)
	for index, value in properties do
		self.Instance[index] = value
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

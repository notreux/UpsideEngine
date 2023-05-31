local methods, constructor = {}, {}
local eventEmitter = require(script.Parent.EventEmitter)

--[[={
	@link BaseObject.md
}=]]

function constructor:BaseObject(parent: Scene)
	local parentType = typeof(parent)
	local parentInstance = parentType == "Instance" and parent or nil

	local instance = Instance.new(self.InstanceType)
	self.Instance = instance

	if parentInstance then
		instance.Parent = parentInstance
	elseif parent and parent.ClassName == "Scene" then
		parent:AddObject(self)
	end

	return instance
end

--[[={
	@desc Sets the properties of the object instance
	@link void.link
}=]]

function methods:Set(properties: Dictionary<string, any>)
	for index, value in properties do
		self.Instance[index] = value
	end
end

--[[={
	@desc Adds a tag to the object
	@link void.link
}=]]

function methods:AddTag(tag: string)
	self.Tags[tag] = true
end

--[[={
	@desc Checks if the object contain the specified tag
	@link boolean.link
}=]]

function methods:HasTag(tag: string): boolean
	return self.Tags[tag]
end

--[[={
	@desc Removes a tag from the object
	@link void.link
}=]]

function methods:RemoveTag(tag: string)
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

return eventEmitter:Extend(script.Name, {
	constructor = constructor,
	methods = methods,
	readonly = {
		Instance = Instance.new("Folder"),
		Scene = "SceneId",
		InstanceType = "ImageLabel",
		Tags = {},
	},
})

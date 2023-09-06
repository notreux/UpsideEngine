local upsideEngine = script.Parent.Parent.Parent
local baseObject = require(upsideEngine.Classes.Internal.BaseObject)

local function setProperty(obj, p, v)
	obj[p] = v
end

local environment = {}
environment.__index = environment

function environment.new(instanceType: string?): Environment
	local self = baseObject.new(instanceType or "Folder")
	self:SetClassName(script.Name)
	self.Content = {}
	self.Count = 0

	return setmetatable(self, environment)
end

function environment:__iter()
	return next, self.Content
end

--[[={
	@desc Gets the object with the specified index
	@link any.link
}=]]

function environment:Get(index: string): any
	return self.Content[index]
end

--[[={
	@desc Adds an object with the specified index, if no parameter is specified it will use the next number of the count property as index
	@link any.link
}=]]

function environment:SetOne(value: any, index: string)
	if not self.Content[index] and value then
		self.Count += 1
	elseif self.Content[index] and not value then
		self.Count -= 1
	end

	self.Content[index] = value
end

--[[={
	@desc Adds an object with the specified index, if no parameter is specified it will use the next number of the count property as index
	@link any.link
}=]]

function environment:AddOne(value: any, index: string)
	assert(self.Content[index] == nil, "This value already exist!")

	self.Count += 1
	self.Content[index or self.Count] = value
end

--[[={
	@desc Removes the object with the specified index
	@link void.link
}=]]

function environment:RemoveOne(index: string)
	assert(self.Content[index], "This value does not exist!")
	self.Content[index or self.Count] = nil
	self.Count -= 1
end

--[[={
	@desc Checks if the environment has a value with the specified index
	@link boolean.link
}=]]

function environment:HasOne(index: string): boolean
	return self.Content[index] ~= nil
end

--[[={
	@desc Checks if the environment contains every specified index and returns a boolean and a dictionary with boolean values, example:
	```lua
	local hasAll, dictionary = treeEnv:Has({
		"Tree1",
		"Tree2",
		"Tree4"
	})

	print(hasAll, dictionary) -- output: false, { Tree1 = true, Tree2 = true, Tree4 = false }
	```
	@tsreturns LuaTuple<[boolean, Dictionary<any, boolean>]>
	@link boolean.link
}=]]

function environment:Has(objects: Array<string>): (boolean, Dictionary<string, boolean>)
	local hasAll = true
	local result = {}

	for _, index in ipairs(objects) do
		local has = self:HasOne(index)
		result[index] = has

		if has == false then
			hasAll = false
		end
	end

	return hasAll, result
end

--[[={
	@desc Adds objects with the specified index
	```lua
	treeEnv:Add({
		"Tree1" = tree.new(),
		"Tree2" = tree.new(),
		"Tree3" = tree.new()
	})

	print(treeEnv:Get("Tree2")) -- output: Tree2
	```
	@link void.link
}=]]

function environment:Add(objects: Dictionary<string, any>)
	for index, object in objects do
		self:AddOne(object, index)
	end
end

--[[={
	@desc Removes the objects with the specified index, example:
	```lua
	treeEnv:Remove({ "Tree1", "Tree2", "Tree3" })
	print(treeEnv:Get("Tree2")) -- output: nil
	```
	@link void.link
}=]]

function environment:Remove(objects: Array<string>)
	for _, index in ipairs(objects) do
		self:RemoveOne(index)
	end
end

--[[={
	@desc Updates the objects with the specified index, example:
	```lua
	treeEnv:Update({
		Tree1 = treeEnv:Get("Tree2"),
		Tree2 = treeEnv:Get("Tree1"),
	})
	```
	@link void.link
}=]]

function environment:Update(objects: Dictionary<string, any>)
	for index, object in objects do
		self.Content[index] = object
	end
end

--[[={
	@desc Finds an object by his name
	@link any.link
}=]]

function environment:FindByName(name: string): any
	for _, object in self.Content do
		if object.Name ~= name then
			continue
		end

		return object
	end

	return
end

--[[={
	@desc Sets the specified property in every object in the environment
	@link void.link
}=]]

function environment:SetProperty(property: string, value: any)
	for _, object in self.Content do
		pcall(setProperty, object, property, value)
	end
end

--[[={
	@desc Executes the specified methods in every object in the environment with the specified parameters
	@link void.link
}=]]

function environment:Run(method: string, ...)
	for _, object in self.Content do
		if typeof(object) == "table" then
			coroutine.wrap(pcall)(object[method] or warn, object, ...)
		end
	end
end

--[[={
	@desc This class is used to storage objects and interact with them in an easier way
	@about
		@Count The amount of objects in this environment
}=]]

return setmetatable(environment, baseObject)

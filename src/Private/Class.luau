local util = require(script.Parent.Util)
local data = require(script.Parent.Parent.AppData:WaitForChild("Data"))

local httpService = game:GetService("HttpService")
local class = { __metatable = "This is a protected class" }
local default = {
	readonly = {},
	rules = {},
	methods = {},
}

local function count(dictionary)
	local elements = 0
	for _ in dictionary do
		elements += 1
	end

	return elements
end

local function getBasicInfo(id, index)
	local restricted = data.restricted[id] or default
	local dirName = restricted.readonly[index] ~= nil and "readonly"
		or restricted.rules[index] ~= nil and "rules"
		or "methods"

	return restricted, dirName
end

function class:__index(index)
	local restricted, dirName = getBasicInfo(self.Id, index)
	return restricted[dirName][index]
end

function class:__newindex(index, value)
	local restricted, dirName = getBasicInfo(self.Id, index)

	assert(dirName, ("%s is not a valid property of %s"):format(index, self.ClassName))
	assert(dirName ~= "readonly", ("%s is a readonly property!"):format(index))
	assert(
		typeof(restricted[dirName][index]) == typeof(value) and dirName == "rules",
		("Invalid value for %s (%s expected, got %s)"):format(index, typeof(restricted[dirName][index]), typeof(value))
	)

	restricted[dirName][index] = value
	if self.Fire then
		self:Fire("Changed", index, self)
	end
end

function class:__tostring()
	return ("%s(%s)"):format(self.ClassName, self.Name)
end

function class:__len()
	local restricted = data.restricted[self.Id]
	local elements = 0

	elements += count(restricted.readonly)
	elements += count(restricted.rules)

	return elements
end

function class:__iter()
	rawset(self, "dir", nil)
	rawset(self, "index", nil)
	return util.Iterate, self
end

function class.new(className, methods)
	local id = tostring(math.random()):split(".")[2]
	local token = httpService:GenerateGUID(true)

	local restricted = {}
	restricted.masterAccess = util.CreateMasterAccess(id, token)
	restricted.token = token
	restricted.methods = methods
	restricted.constructor = {}
	restricted.readonly = { ClassName = className }
	restricted.private = {}
	restricted.rules = {}

	data.restricted[id] = restricted
	return setmetatable({ Id = id }, class)
end

return class

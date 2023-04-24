local upsideEngine = script.Parent.Parent.Parent.Parent
local data = require(upsideEngine.AppData.Data)
local iterate = require(script.Parent.Iterate)

local masterAccess = { __metatable = "MasterAccess" }
local default = {
	readonly = {},
	rules = {},
	methods = {},
	private = {},
}

local function getBasicInfo(self, index)
	local id = rawget(self, "Id") or ""
	local token = rawget(self, "Token") or ""

	local restricted = data.restricted[id] or default
	local dirName = restricted.private[index] ~= nil and "private"
		or restricted.readonly[index] ~= nil and "readonly"
		or restricted.rules[index] ~= nil and "rules"
		or "methods"

	if restricted.token ~= token then
		return default, dirName
	end

	return restricted, dirName
end

function masterAccess:__index(index)
	local restricted, dirName = getBasicInfo(self, index)
	return restricted[dirName][index]
end

function masterAccess:__newindex(index, value)
	local restricted, dirName = getBasicInfo(self, index)
	local message = ("%s is not a valid property of %s"):format(index, self.ClassName)

	assert(restricted[dirName][index] ~= nil, message)
	restricted[dirName][index] = value
end

function masterAccess:__iter()
	rawset(self, "dir", nil)
	rawset(self, "index", nil)
	return iterate, self
end

function masterAccess:__tostring()
	return "MasterAccess"
end

return function(id, token)
	return setmetatable({ Id = id, Token = token }, masterAccess)
end

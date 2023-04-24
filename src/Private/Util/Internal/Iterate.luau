local appData = script.Parent.Parent.Parent.Parent.AppData
local data = require(appData.Data)
local default = {
	readonly = {},
	rules = {},
	methods = {},
}

local function readFrom(object, dir)
	local restricted = data.restricted[object.Id] or default
	local key, value = next(restricted[dir], object.index)

	rawset(object, "index", value ~= nil and key or nil)
	rawset(object, "dir", key ~= nil and dir or "rules")

	return key, value
end

return function(object)
	local dir = object.dir or "readonly"
	local key, value = readFrom(object, dir)

	if key then
		return key, value
	elseif dir ~= "rules" then
		return readFrom(object, "rules")
	end

	return
end

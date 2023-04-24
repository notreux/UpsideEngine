local appData = script.Parent.Parent.Parent.Parent.AppData
local data = require(appData.Data)

local upsideFunction = {}
upsideFunction.__metatable = "UpsideFunction"
upsideFunction.__index = "nil"
upsideFunction.__newindex = "nil"

function upsideFunction:__call(object, ...)
	local restricted = data.restricted[object.Id]
	local execute = self.execute
	return execute(restricted.masterAccess, ...)
end

function upsideFunction:__tostring()
	return "UpsideFunction"
end

return function(Func)
	return setmetatable({
		execute = Func,
	}, upsideFunction)
end

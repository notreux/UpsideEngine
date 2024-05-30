local isEqual = require(script.Parent.Parent.Parent.Private.Util.Internal.IsEqual)
local actrees = {}
actrees.__index = actrees

function actrees.new()
	return setmetatable({
		__actors = {},
		__cache = {},
	}, actrees)
end

function actrees:AddActor(actor)
	table.insert(self.__actors, actor)
end

function actrees:SetVariable(name, value)
	local equal = isEqual(self.__cache[name], value)
	local method = if equal then "updateVariable" else "setVariable"
	local arg = if equal then nil else value

	for _, actor in self do
		actor.instance:SendMessage(method, name, arg)
	end
end

function actrees:__iter()
	return next, self.__actors
end

return actrees

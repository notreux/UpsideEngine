local actrees = {}
actrees.__index = actrees

function actrees.new()
	return setmetatable({
		__actors = {},
	}, actrees)
end

function actrees:AddActor(actor)
	table.insert(self.__actors, actor)
end

function actrees:SetVariable(name, value)
	for _, actor in self do
		actor.instance:SendMessage("setVariable", name, value)
	end
end

function actrees:__iter()
	return next, self.__actors
end

return actrees

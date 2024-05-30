local path = {}
function path.getRoute(object: Instance): string
	local route = {}
	local baseRoute = {}
	local parent = object

	while parent ~= game do
		table.insert(baseRoute, parent.Name)
		parent = parent.Parent
	end

	for i = #baseRoute, 1, -1 do
		table.insert(route, baseRoute[i])
	end

	return table.concat(route, "/", 1, #route)
end

function path.readRoute(url: string): Instance
	local route = url:split("/")
	local instance = game

	for _, index in route do
		instance = instance[index]
	end

	return instance
end

return path

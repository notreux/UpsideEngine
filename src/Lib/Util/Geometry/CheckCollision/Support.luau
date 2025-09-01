return function(object, direction)
	if object.shape == "circle" then
		if direction.X == 0 and direction.Y == 0 then
			return object.centre
		end

		local unitDirection = direction.Unit
		if unitDirection.X == 0 and unitDirection.Y == 0 then
			return object.centre
		end

		return object.centre + object.radius * unitDirection
	end

	if not object.area or #object.area == 0 then
		return object.centre
	end

	local furthestDistance = -math.huge
	local furthestVertex = object.area[1]

	for i = 1, #object.area do
		local vertex = object.area[i]
		local distance = vertex:Dot(direction)
		if distance > furthestDistance then
			furthestDistance = distance
			furthestVertex = vertex
		end
	end

	return furthestVertex
end

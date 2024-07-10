return function(object, direction)
	if object.shape == "circle" then
		local unitDirection = direction.Unit
		unitDirection = if unitDirection.Magnitude ~= 0 then unitDirection else Vector3.zero

		return object.centre + object.radius * unitDirection
	end

	local furthestDistance = -math.huge
	local furthestVertex = nil

	for _, vertex in object.area do
		local distance = vertex:Dot(direction)
		if distance < furthestDistance then
			continue
		end

		furthestDistance = distance
		furthestVertex = vertex
	end

	return furthestVertex
end

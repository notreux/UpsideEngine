function rotateVector(v, a)
	local sin, cos = math.sin(a), math.cos(a)
	return Vector2.new(v.X * cos - v.Y * sin, v.X * sin + v.Y * cos)
end

return function(object)
	local aSize, aPosition = object.AbsoluteSize, object.AbsolutePosition
	local center, rotation = aPosition + aSize / 2, math.rad(object.Rotation)
	local world_cords = {
		aPosition,
		Vector2.new(aPosition.X + aSize.X, aPosition.Y),
		aPosition + aSize,
		Vector2.new(aPosition.X, aPosition.Y + aSize.Y),
	}

	local corners = {}
	for i, corner in world_cords do
		corners[i] = center + rotateVector(corner - center, rotation)
	end

	return corners
end

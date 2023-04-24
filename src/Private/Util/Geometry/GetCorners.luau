function rotateVector(v, a)
	return Vector2.new(
		v.X * math.cos(a) - v.Y * math.sin(a), 
		v.X * math.sin(a) + v.Y * math.cos(a)
	)
end

return function(object)
	local corners, rot, ap, as = {}, math.rad(object.Rotation), object.AbsolutePosition, object.AbsoluteSize
	local center, world_cords = ap + as / 2, {
			ap,
			Vector2.new(ap.X + as.X, ap.Y),
			Vector2.new(ap.X + as.X, ap.Y + as.Y),
			Vector2.new(ap.X, ap.Y + as.Y),
		}

	for i, corner in ipairs(world_cords) do
		corners[i] = center + rotateVector(corner - center, rot)
	end

	return corners
end
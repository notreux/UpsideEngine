return function(object)
	local size, position = object.AbsoluteSize, object.AbsolutePosition
	local center = position + size * 0.5
	local corners = {
		position,
		Vector2.new(position.X + size.X, position.Y),
		position + size,
		Vector2.new(position.X, position.Y + size.Y),
	}

	if object.Rotation == 0 then
		return corners
	end

	local rotation = math.rad(object.Rotation)
	local sin, cos = math.sin(rotation), math.cos(rotation)

	for i = 1, #corners do
		local corner = corners[i]

		local XDistance = corner.X - center.X
		local YDistance = corner.Y - center.Y

		-- stylua: ignore start
		corners[i] = Vector2.new(
			center.X + XDistance * cos - YDistance * sin, 
			center.Y + XDistance * sin + YDistance * cos
		)
		-- stylua: ignore end
	end

	return corners
end

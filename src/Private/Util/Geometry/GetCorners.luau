return function(object)
	local instance = object.Instance
	local size, position = instance.AbsoluteSize, instance.AbsolutePosition

	local center = position + size * 0.5
	local corners = {}

	for i = 1, #object.Hitbox do
		local point = object.Hitbox[i]
		local hitboxSize = size * object.HitboxScale
		local alignment = size * (1 - math.clamp(object.HitboxScale, 0, 1)) * 0.5

		table.insert(corners, position + alignment + hitboxSize * point)
	end

	if instance.Rotation == 0 then
		return corners
	end

	local rotation = math.rad(instance.Rotation)
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

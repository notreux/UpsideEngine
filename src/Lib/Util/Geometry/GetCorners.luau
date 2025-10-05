return function(object)
	local instance = object.Instance
	local size = instance.AbsoluteSize
	local position = instance.AbsolutePosition

	size = Vector3.new(size.X, size.Y, 0)
	position = Vector3.new(position.X, position.Y, 0)

	local hitboxSize = size * object.HitboxScale
	local alignment = size * (1 - math.clamp(object.HitboxScale, 0, 1)) * 0.5

	local center = position + alignment + hitboxSize * 0.5
	local corners = {}

	for i = 1, #object.Hitbox do
		local point = object.Hitbox[i]
		table.insert(corners, position + alignment + hitboxSize * point)
	end

	if instance.Rotation ~= 0 then
		local rotation = math.rad(instance.Rotation)
		local sin, cos = math.sin(rotation), math.cos(rotation)

		for i = 1, #corners do
			local corner = corners[i]
			local dx, dy = corner.X - center.X, corner.Y - center.Y

			-- stylua: ignore start
			corners[i] = Vector3.new(
				center.X + dx * cos - dy * sin,
				center.Y + dx * sin + dy * cos,
				0
			)
			-- stylua: ignore end
		end
	end

	return corners
end

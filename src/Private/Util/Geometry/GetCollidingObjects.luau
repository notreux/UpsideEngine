local checkCollision = require(script.Parent.CheckCollision)
local getDistance = require(script.Parent.Parent.Math.GetDistance)

local function isFar(object, other)
	local osize = object.AbsoluteSize * 2
	local msize = other.AbsoluteSize * 2

	local distance = getDistance(object.AbsolutePosition, other.AbsolutePosition)
	local x = osize.X + msize.X
	local y = osize.Y + msize.Y

	return distance > x * x and distance > y * y
end

local function shouldSkip(object, other)
	return object.Id == other.Id
		or other.CollisionGroup ~= object.CollisionGroup
		or other.CollisionBlacklist[object.Id]
		or object.CollisionBlacklist[other.Id]
end

function toVector3(v2)
	return Vector3.new(v2.X, v2.Y, 0)
end

local function getRotatedArea(instance, area, centre)
	if instance.Rotation == 0 then
		return area
	end

	local rotation = math.rad(instance.Rotation)
	local sin, cos = math.sin(rotation), math.cos(rotation)

	for i, vertex in area do
		local XDistance = vertex.X - centre.X
		local YDistance = vertex.Y - centre.Y

		-- stylua: ignore start
		vertex = Vector3.new(
			centre.X + XDistance * cos - YDistance * sin, 
			centre.Y + XDistance * sin + YDistance * cos, 
			0
		)
		-- stylua: ignore end
		area[i] = vertex
	end

	return area
end

local function getObjectData(object, velocity)
	local area = {}
	local instance = object.Instance

	local position = toVector3(instance.AbsolutePosition + velocity)
	local size = toVector3(instance.AbsoluteSize)

	local centre = position + size * 0.5
	local radius = if object.Shape == "circle" then (size.X / 2) * object.HitboxScale else nil

	for i, vertex in object.Hitbox do
		local hitboxSize = size * object.HitboxScale
		local alignment = size * (1 - math.clamp(object.HitboxScale, 0, 1)) * 0.5
		area[i] = position + alignment + hitboxSize * vertex
	end

	return {
		radius = radius,
		shape = object.Shape,
		centre = centre,
		area = getRotatedArea(instance, area, centre),
	}
end

local function checkByShape(objects, object, velocity)
	local collisions = {}
	local objectData = getObjectData(object, velocity)

	for _, other in objects do
		local isFar = isFar(object.Instance, other.Instance)
		local collision, otherData, moveVector = nil, nil, Vector2.zero

		if shouldSkip(object, other) or isFar then
			continue
		end

		otherData = getObjectData(other, Vector2.zero)
		collision, moveVector = checkCollision(objectData, otherData)

		if not collision then
			continue
		end

		moveVector *= if other.Anchored then 1 else 0.5
		velocity -= moveVector
		objectData = getObjectData(object, velocity)

		table.insert(collisions, {
			object = other,
			moveVector = moveVector,
		})
	end

	return collisions
end

return checkByShape

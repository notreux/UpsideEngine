local getDistance = require(script.Parent.Parent.Math.GetDistance)
local solvers = {}
for _, solver in script:GetChildren() do
	solvers[solver.Name] = require(solver)
end

local solve = solvers.Polygon
local function isFar(object, meta)
	local osize = object.AbsoluteSize * 2
	local msize = meta.AbsoluteSize * 2

	local distance = getDistance(object.AbsolutePosition, meta.AbsolutePosition)
	local x = osize.X + msize.X
	local y = osize.Y + msize.Y

	return distance > x * x and distance > y * y
end

local function shouldSkip(object, meta)
	return not meta.TrackCollisions
		or object.Id == meta.Id
		or meta.CollisionGroup ~= object.CollisionGroup
		or meta.CollisionBlacklist[object.Id]
		or object.CollisionBlacklist[meta.Id]
end

local function isColliding(object, meta, stop)
	local isColliding, mtv = solve(object, meta)
	if isColliding then
		stop = stop or (meta.CanCollide and not meta.Collisions[object.Id])
		return stop, mtv
	end

	return stop, Vector2.zero
end

local function checkByShape(object, distance, objects)
	local xStop = false
	local yStop = false
	local instance = object.Instance

	local collisions = {}
	local xFakeObject = {
		Hitbox = object.Hitbox,
		Instance = {
			AbsolutePosition = instance.AbsolutePosition,
			AbsoluteSize = instance.AbsoluteSize,
			Rotation = instance.Rotation,
		},
	}

	local x, xMtv = Vector2.new(distance.X, 0), nil
	local y, yMtv = Vector2.new(0, distance.Y), nil

	local yFakeObject = table.clone(xFakeObject)
	yFakeObject.Instance.AbsolutePosition += y
	xFakeObject.Instance.AbsolutePosition += x

	for _, meta in objects do
		local isXFar = isFar(xFakeObject.Instance, meta.Instance)
		local isYFar = isFar(yFakeObject.Instance, meta.Instance)

		if shouldSkip(object, meta) or isXFar and isYFar then
			meta.Instance.ImageColor3 = Color3.fromRGB(255, 255, 255)
			continue
		end

		xMtv = Vector2.zero
		yMtv = Vector2.zero

		if not isXFar then
			xStop, xMtv = isColliding(xFakeObject, meta, xStop)
		end

		if not isYFar then
			yStop, yMtv = isColliding(yFakeObject, meta, yStop)
		end

		meta.Instance.ImageColor3 = Color3.fromRGB(47, 47, 47)
		collisions[meta.Id] = {
			object = meta,
			mtv = Vector2.new(xMtv.X, yMtv.Y),
		}
	end

	return collisions, xStop and yStop
end

return checkByShape

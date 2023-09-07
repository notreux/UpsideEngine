local getDistance = require(script.Parent.Parent.Math.GetDistance)
local solvers = {}
for _, solver in script:GetChildren() do
	solvers[solver.Name] = require(solver)
end

local solve = solvers.Polygon
local function isFar(object, meta)
	local osize = object.AbsoluteSize * 4
	local msize = meta.AbsoluteSize * 4

	local distance = getDistance(object.AbsolutePosition, meta.AbsolutePosition)
	local x = osize.X + msize.X
	local y = osize.Y + msize.Y

	return distance > x * x and distance > y * y
end

local function shouldSkip(object, meta)
	return not meta.TrackCollisions
		or isFar(object.Instance, meta.Instance)
		or object.Id == meta.Id
		or meta.CollisionGroup ~= object.CollisionGroup
		or meta.CollisionBlacklist[object.Id]
		or object.CollisionBlacklist[meta.Id]
end

local function checkByShape(object, position, objects)
	local stop = false
	local instance = object.Instance

	local collisions = {}
	local fakeObject = {
		Hitbox = object.Hitbox,
		Instance = {
			AbsolutePosition = position,
			AbsoluteSize = instance.AbsoluteSize,
			Rotation = instance.Rotation,
		},
	}

	for _, meta in objects do
		if shouldSkip(object, meta) then
			continue
		end

		local isColliding, mtv = solve(fakeObject, meta)
		if isColliding then
			stop = stop or (meta.CanCollide and not meta.Collisions[object.Id])
			collisions[meta.Id] = {
				object = meta,
				mtv = mtv,
			}
		end
	end

	return collisions, stop
end

return checkByShape

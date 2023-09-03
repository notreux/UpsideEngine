local solvers = {}

for _, solver in script:GetChildren() do
	solvers[solver.Name] = require(solver)
end

local solve = solvers.Polygon
local function shouldSkip(object, meta)
	return not meta.TrackCollisions
		or meta.CollisionGroup ~= object.CollisionGroup
		or meta.CollisionBlacklist[object.Id]
		or object.CollisionBlacklist[meta.Id]
		or object.Id == meta.Id
end

local function checkByShape(object, position, scene)
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

	for _, meta in scene.Objects do
		if shouldSkip(object, meta) then
			continue
		end

		local isColliding, mtv = solve(fakeObject, meta)
		if isColliding then
			stop = stop or (meta.CanCollide and not meta.Collisions[object.Id])
			table.insert(collisions, {
				object = meta,
				mtv = mtv,
			})
		end
	end

	return collisions, stop
end

return function(object, ...)
	return checkByShape(object, ...)
end

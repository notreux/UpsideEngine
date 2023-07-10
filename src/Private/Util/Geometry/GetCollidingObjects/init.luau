local solvers = {}

for _, solver in script:GetChildren() do
	solvers[solver.Name] = require(solver)
end

local function shouldSkip(object, meta)
	return not meta.TrackCollisions
		or meta.CollisionGroup ~= object.CollisionGroup
		or meta.CollisionBlacklist[object.Id]
		or object.CollisionBlacklist[meta.Id]
		or object.Id == meta.Id
end

local function toOffset(instance, vertex)
	return instance.AbsoluteSize * vertex
end

local function checkByPoint(object, position, scene)
	local instance = object.Instance
	local hitbox = object.Hitbox
	local collisions = {}

	for i = 1, #hitbox do
		local rayParams = {
			From = position + toOffset(instance, hitbox[i]),
			To = position + toOffset(instance, hitbox[i + 1] or hitbox[1]),
			FilterType = "Blacklist",
			List = { object },
		}

		local _, results = scene:Raycast(rayParams)
		for _, result in results do
			local meta = result.Object
			if shouldSkip(object, result.Object) then
				continue
			end

			table.insert(collisions, {
				object = meta,
				mtv = result.Object.AbsolutePosition - result.Position - result.Object.AbsoluteSize / 2,
			})
		end
	end

	return collisions
end

local function checkByShape(object, position, scene)
	local stop = false
	local instance = object.Instance

	local collisions = {}
	local fakeInstance = {
		AbsolutePosition = position,
		AbsoluteSize = instance.AbsoluteSize * object.HitboxScale,
		Rotation = instance.Rotation,
	}

	for _, meta in scene.Objects do
		if shouldSkip(object, meta) then
			continue
		end

		local solve = solvers[object.HitboxShape]
		local isColliding, mtv = solve(fakeInstance, meta.Instance)

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
	if object.HitboxShape == "Custom" then
		return checkByPoint(object, ...)
	else
		return checkByShape(object, ...)
	end
end

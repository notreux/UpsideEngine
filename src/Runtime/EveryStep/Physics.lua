local upsideEngine = script.Parent.Parent.Parent
local util = require(upsideEngine.Private.Util)

local max = 10000
local movers = { "Velocity", "Force" }
local recentCollisions = {}

local function getRecentCollisions(object)
	local recent = recentCollisions[object.Id]
	if not recent then
		recent = {}
		recentCollisions[object.Id] = recent
	end

	return recent
end

local function emit(self, meta, active)
	local current = self.Collisions[meta.Id]
	local recentC = getRecentCollisions(self)
	local iterations = recentC[meta.Id] or 0

	if current == active then
		recentC[meta.Id] = 5
		iterations = 5
		return
	elseif iterations > 0 then
		return
	end

	self.Collisions[meta.Id] = active or nil
	self:Fire(active and "Collision" or "CollisionEnd", meta)

	rawset(recentC, meta.Id, 5)
end

return function(scene, deltaTime)
	for _, object in scene.Objects do
		if not (object:IsA("PhysicalObject") and object.TrackCollisions) then
			continue
		end

		local instance, position, collisions = object.Instance, nil, nil
		local absolutePosition = instance.AbsolutePosition

		local colliding, recentC = {}, getRecentCollisions(object)
		local smtv = Vector2.zero

		for i = 1, 4 do
			position = absolutePosition + (object.Force + object.Velocity) * deltaTime / i
			collisions = util.GetCollidingObjects(object, position, scene)

			if #collisions > 0 then
				break
			end
		end

		for _, collision in ipairs(collisions) do
			smtv += collision.mtv

			colliding[collision.object.Id] = true
			emit(object, collision.object, true)
		end

		for id in pairs(object.Collisions) do
			emit(object, scene.Objects[id], colliding[id])
		end

		for id, iterations in pairs(recentC) do
			recentC[id] -= 1
			if iterations < 0 then
				recentC[id] = nil
			end
		end

		if object.Anchored or not object.CanCollide then
			continue
		end

		for _, mover in ipairs(movers) do
			object[mover] = Vector2.new(smtv.X == 0 and object[mover].X or 0, smtv.Y == 0 and object[mover].Y or 0)
		end

		position -= smtv
		instance.Position -= util.ToUDim2(absolutePosition - position)

		object.IsGrounded = object.Force.Y == 0
		object.Force += Vector2.new(0, math.clamp(object.Mass * 10, -max, max)) * deltaTime
	end
end

local upsideEngine = script.Parent.Parent.Parent
local util = require(upsideEngine.Private.Util)

local max = 10000
local recentCollisions = {}

local function adaptToCollisions(object, property, smtv)
	object[property] = Vector2.new(smtv.X == 0 and object[property].X or 0, smtv.Y == 0 and object[property].Y or 0)
end

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

		local instance = object.Instance
		local absolutePosition = instance.AbsolutePosition

		local colliding, recentC = {}, getRecentCollisions(object)
		local distance = (object.Force + object.Velocity) * deltaTime

		local smtv, position = Vector2.zero, nil
		local stop, collisions = nil, nil

		for i = 4, 1, -1 do
			local dis = distance / i
			position = absolutePosition + dis
			collisions, stop = util.GetCollidingObjects(object, position, scene)

			if stop and object.CanCollide then
				distance = dis
				break
			end
		end

		for _, collision in collisions do
			local meta = collision.object
			if object.CanCollide and meta.CanCollide then
				smtv += collision.mtv
			end

			colliding[collision.object.Id] = true
			emit(object, collision.object, true)
		end

		for id in object.Collisions do
			local obj = scene.Objects[id]
			if not obj then
				continue
			end

			emit(object, obj, colliding[id])
		end

		for id, iterations in recentC do
			recentC[id] -= 1
			if iterations < 0 then
				recentC[id] = nil
			end
		end

		if object.Anchored then
			continue
		elseif not object.ConstantVelocityEnabled then
			adaptToCollisions(object, "Velocity", smtv)
		end

		adaptToCollisions(object, "Force", smtv)
		distance -= smtv
		instance.Position += util.ToUDim2(distance)

		object.IsGrounded = object.Force.Y == 0
		object.Force += Vector2.new(0, math.clamp(object.Mass * 10, -max, max)) * deltaTime
	end
end

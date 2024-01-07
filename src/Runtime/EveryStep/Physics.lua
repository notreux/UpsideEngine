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
		return
	elseif iterations > 0 then
		return
	end

	self.Collisions[meta.Id] = active or nil
	self:Fire(active and "Collision" or "CollisionEnd", meta)
	rawset(recentC, meta.Id, 5)
end

return function(scene, deltaTime)
	local objects = {}
	local freefall = {}

	for index, object in scene.Objects do
		if
			not object:IsA("PhysicalObject")
			or not object.TrackCollisions
			or not object.Instance.Visible
			or scene.OnlyTrackVisible
				and util.IsOutScreen(object.Instance.AbsolutePosition, object.Instance.AbsoluteSize)
		then
			continue
		elseif object.Anchored then
			objects[index] = object
			continue
		end

		freefall[index] = object
	end

	for _, object in freefall do
		local instance = object.Instance
		local smtv = Vector2.zero

		local colliding, recentC = {}, getRecentCollisions(object)
		local distance = (object.Force + object.Velocity) * deltaTime
		local stop, collisions, dis = nil, nil, nil

		for i = 4, 1, -1 do
			dis = distance / i
			collisions, stop = util.GetCollidingObjects(object, dis, objects)

			if stop and object.CanCollide then
				break
			end
		end

		for _, collision in collisions do
			local meta = collision.object
			if object.CanCollide and meta.CanCollide then
				smtv += collision.mtv
			end

			colliding[collision.object.Id] = true
			emit(meta, object, true)
			emit(object, meta, true)
		end

		for id in object.Collisions do
			local meta = scene.Objects:Get(id)
			if not meta then
				continue
			end

			emit(object, meta, colliding[id])
			emit(meta, object, colliding[id])
		end

		for id, iterations in recentC do
			recentC[id] -= 1
			if iterations < 0 then
				recentC[id] = nil
			end
		end

		adaptToCollisions(object, "Velocity", smtv)
		adaptToCollisions(object, "Force", smtv)
		distance = Vector2.new(
			math.round(smtv.X == 0 and distance.X or dis.X),
			math.round(smtv.Y == 0 and distance.Y or dis.Y)
		)

		instance.Position += util.ToUDim2(distance - smtv)
		object.IsGrounded = object.Force.Y == 0
		object.Force += Vector2.new(0, math.clamp(object.Mass * 10, -max, max)) * deltaTime
	end
end

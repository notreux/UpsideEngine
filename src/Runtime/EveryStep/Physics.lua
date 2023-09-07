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

local function getCollidingObjects(distance, object, objects)
	local absolutePosition = object.Instance.AbsolutePosition
	local stop, collisions, dis, position = nil, nil, nil, nil

	for x = 4, 1, -1 do
		dis = distance / x
		position = absolutePosition + dis
		collisions, stop = util.GetCollidingObjects(object, position, objects)

		if stop and object.CanCollide then
			break
		end
	end

	return dis, collisions
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

		local xDis, xCollisions = getCollidingObjects(Vector2.new(distance.X, 0), object, objects)
		local yDis, yCollisions = getCollidingObjects(Vector2.new(0, distance.Y), object, objects)

		for index, collision in yCollisions do
			local xCollision = xCollisions[index]
			if not xCollision then
				xCollisions[index] = collision
				continue
			end

			xCollision.mtv += Vector2.new(xCollision.mtv.X, collision.mtv.Y)
		end

		for _, collision in xCollisions do
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

		if not object.ConstantVelocityEnabled then
			adaptToCollisions(object, "Velocity", smtv)
		end

		adaptToCollisions(object, "Force", smtv)
		distance = Vector2.new(
			smtv.X == 0 and math.round(distance.X) or math.round(xDis.X),
			smtv.Y == 0 and math.round(distance.Y) or math.round(yDis.Y)
		)
		instance.Position += util.ToUDim2(distance - smtv)

		object.IsGrounded = object.Force.Y == 0
		object.Force += Vector2.new(0, math.clamp(object.Mass * 10, -max, max)) * deltaTime
	end
end

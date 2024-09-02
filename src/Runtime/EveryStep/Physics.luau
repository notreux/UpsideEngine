local upsideEngine = script.Parent.Parent.Parent
local ToUDim2 = require(script.Parent.Parent.Parent.Private.Util.DataType.ToUDim2)
local getCollidingObjects = require(script.Parent.Parent.Parent.Private.Util.Geometry.GetCollidingObjects)
local crossPlatformService = require(script.Parent.Parent.Parent.Services.CrossPlatformService)
local util = require(upsideEngine.Private.Util)

local function emit(self, meta, active)
	local oldState = self.Collisions[meta.Id]
	if oldState == active then
		return
	end

	local eventName = if active then "Collision" else "CollisionEnd"
	self.Collisions[meta.Id] = active or nil
	self:Fire(eventName, meta)
end

function applyBuoyancy(scene, object, fluid)
	local height = object.Instance.AbsoluteSize.Y
	local bottom = object.Instance.AbsolutePosition.Y + height
	local top = fluid.Instance.AbsolutePosition.Y

	local submergedVolume = math.min(bottom - top, height)
	local submergedRatio = submergedVolume / height

	if object:IsA("Fluid") or object.Anchored then
		return
	end

	local tideEffect = fluid.WavesAmplitude * (math.sin(fluid.WavesSpeed * os.clock()))
	local buoyancyForce = fluid.Density * submergedRatio * height * scene.Gravity.Y + tideEffect
	local dragForce = -fluid.Viscosity * object.Velocity

	object:ApplyForce(Vector2.new(0, -buoyancyForce))
	object:ApplyForce(dragForce)
end

local function update(scene, object, deltaTime)
	if object.Anchored then
		return
	end

	local sideView = crossPlatformService.SideView
	local mass = math.max(object.Mass, 1)

	object:ApplyForce(scene.Gravity * object.Mass)
	object.Acceleration = object.Force * (1 / mass)
	object.Velocity += object.Acceleration * deltaTime

	local velocity = object.Velocity
	local moveVector = velocity * deltaTime

	local friction = math.max(1 - object.Friction * deltaTime, 0)
	local vx = velocity.X * friction
	local vy = if sideView then velocity.Y else velocity.Y * friction

	object.Force = Vector2.zero
	object.Velocity = Vector2.new(vx, vy)

	return moveVector
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

		objects[index] = object
		freefall[index] = object
	end

	for _, object in freefall do
		local x, y = 0, 0
		local instance = object.Instance
		local velocity = update(scene, object, deltaTime)
		local iterations = (object.Velocity / instance.AbsoluteSize).Magnitude
		iterations = math.round(1 + iterations * deltaTime * 10)

		local collisionCount, collisions = 0, {}
		local colliding = {}

		for i = iterations, 1, -1 do
			local vel = velocity / i
			colliding = getCollidingObjects(objects, object, vel)

			if #colliding < collisionCount then
				velocity = velocity / (i + 1)
				break
			end

			collisionCount = #colliding
		end

		for _, collision in colliding do
			local other = collision.object
			local mv = collision.moveVector
			local isFluid = other:IsA("Fluid")

			collisions[collision.object.Id] = true
			emit(other, object, true)
			emit(object, other, true)

			if isFluid then
				applyBuoyancy(scene, object, other)
				continue
			elseif not object.CanCollide or not other.CanCollide then
				continue
			end

			x = math.abs(mv.X) > math.abs(x) and mv.X or x
			y = math.abs(mv.Y) > math.abs(y) and mv.Y or y
		end

		for id in object.Collisions do
			local meta = scene.Objects:Get(id)
			if not meta then
				continue
			end

			emit(object, meta, collisions[id])
			emit(meta, object, collisions[id])
		end

		if object.Anchored then
			continue
		end

		local moveVector = Vector2.new(x, y)
		instance.Position += ToUDim2(velocity - moveVector)
		object.IsGrounded = y > 0
		object.Velocity -= moveVector
	end
end

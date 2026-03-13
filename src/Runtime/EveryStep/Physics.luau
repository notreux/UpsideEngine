--!native
--!optimize 2
local upsideEngine = script.Parent.Parent.Parent
local ToUDim2 = require(script.Parent.Parent.Parent.Lib.Util.DataType.ToUDim2)
local getCollidingObjects = require(script.Parent.Parent.Parent.Lib.Util.Geometry.GetCollidingObjects)
local SpatialGrid = require(script.Parent.Parent.Parent.Lib.Util.Geometry.SpatialGrid)
local crossPlatformService = require(script.Parent.Parent.Parent.Services.CrossPlatformService)
local util = require(upsideEngine.Lib.Util)

local MAX_ITERATIONS = 4
local grid = SpatialGrid.new(256)
local nearbyBuffer = {}
local seenBuffer = {}

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

local GRAVITY_SCALE = 100
local FORCE_SCALE = 10

local function update(scene, object, deltaTime)
	if object.Anchored then
		return
	end

	local sideView = crossPlatformService.SideView
	local mass = math.max(object.Mass, 1)

	object.Acceleration = scene.Gravity * GRAVITY_SCALE + (object.Force * FORCE_SCALE) / mass
	object.Velocity += object.Acceleration * deltaTime

	local friction = math.max(1 - object.Friction * deltaTime, 0)
	local vx = object.Velocity.X * friction
	local vy = if sideView then object.Velocity.Y else object.Velocity.Y * friction
	object.Velocity = Vector2.new(vx, vy)

	object.Force = Vector2.zero

	return object.Velocity * deltaTime
end

local GRID_THRESHOLD = 30
local objects = {}
local freefall = {}
local collisionsBuffer = {}

return function(scene, deltaTime)
	table.clear(objects)
	table.clear(freefall)
	local objectCount = 0
	local useGrid = false

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
		objectCount += 1
	end

	useGrid = objectCount >= GRID_THRESHOLD
	if useGrid then
		grid:clear()
		for _, object in objects do
			grid:insert(object)
		end
	end

	for _, object in freefall do
		local x, y = 0, 0
		local instance = object.Instance
		local velocity = update(scene, object, deltaTime)
		local absSize = instance.AbsoluteSize
		local sizeMax = math.max(absSize.X, absSize.Y, 1)
		local iterations = math.min(math.ceil(velocity.Magnitude / sizeMax), MAX_ITERATIONS)
		iterations = math.max(iterations, 1)

		table.clear(collisionsBuffer)
		local collisions = collisionsBuffer
		local colliding = {}
		local nearby = if useGrid then grid:query(object, nearbyBuffer, seenBuffer) else objects

		for i = 1, iterations do
			local vel = velocity * (i / iterations)
			colliding = getCollidingObjects(nearby, object, vel)

			if #colliding > 0 then
				velocity = vel
				break
			end
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

			x += mv.X
			y += mv.Y
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
		object.IsGrounded = y > 0
		instance.Position += ToUDim2(velocity - moveVector)
		object.Velocity -= moveVector
	end
end

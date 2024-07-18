local upsideEngine = script.Parent.Parent.Parent
local staticObject = require(upsideEngine.Classes.Public.StaticObject)

local physicalObject = {}
physicalObject.__index = physicalObject

--[[={
	@link PhysicalObject.md
}=]]

function physicalObject.new(): PhysicalObject
	local self = staticObject.new()
	self:SetClassName(script.Name)
	self.Force = Vector2.zero
	self.Velocity = Vector2.zero
	self.Acceleration = Vector2.zero
	self.Collisions = {}
	self.CollisionBlacklist = {}
	self.Hitbox = {
		Vector3.zero,
		Vector3.new(1, 0),
		Vector3.new(1, 1),
		Vector3.new(0, 1),
	}

	self.Shape = "Custom"
	self.Mass = 100
	self.HitboxScale = 1
	self.CollisionGroup = 0
	self.Friction = 4
	self.Anchored = true
	self.CanCollide = true
	self.IsGrounded = false
	self.TrackCollisions = true

	return setmetatable(self, physicalObject)
end

--[[={
	@desc Applies force to the object
	@link PhysicalObject.md
}=]]

function physicalObject:ApplyForce(force: Vector2)
	self.Force += force
end

--[[={
	@desc This class is used to create objects with physics
	@about
		@Collisions This table stores all the active collisions
		@CollisionBlacklist This dictionary stores all the blacklisted objects, to blacklist an object do it like this:
		```lua
		CollisionBlacklist[object.Id] = true
		```
		@Mass The object mass
		@CollisionGroup A number which indicates the collision group of the object, the object only can collide with other objects with the same CollisionGroup
		@Anchored This property defines if the object should have physics or not
		@CanCollide This property defines if the object can collide with other objects
		@IsGrounded This property indicates if the object is touching the ground
		@TrackCollisions This property defines if the object is going to have physics and collisions or not
		@Force Is the force which is applied in the moment to the object
		@Velocity Is the velocity applied to the object
		@Hitbox This the CollisionMask of the object
		@HitboxScale Change this property to change the hitbox size, the default value is 1
		@Shape Specifies the geometric shape of the physical object, which can be "circle" and "custom" for polygons, custom is has box hitbox by default, also is the default shape.
		@Friction Determines the resistance to sliding motion between this object and another surface, influencing how quickly it slows down.
		@Acceleration Defines the rate of change of velocity for the physical object, initially set to zero.
	@events 
		@Collision Params -> [PhysicalObject](PhysicalObject.md)
		This event is fired when the object collides with other object
		@CollisionEnd Params -> [PhysicalObject](PhysicalObject.md)
		This event is fired when the object finish the collision with other object
}=]]

return setmetatable(physicalObject, staticObject)

local upsideEngine = script.Parent.Parent.Parent
local sprite = require(upsideEngine.Classes.Public.Sprite)
local methods = {}

local function check(greater, axePos, targetAxe)
	return if greater then axePos >= targetAxe else axePos <= targetAxe
end

local function jump(self, jumpPower)
	self.Velocity -= Vector2.new(0, jumpPower)
	task.wait(0.3)
	self.Velocity += Vector2.new(0, jumpPower)
end

local function getAxeData(self, target, axe)
	local absPos = self.Instance.Position
	absPos = Vector2.new(absPos.X.Offset, absPos.Y.Offset)

	local greater = target[axe] > absPos[axe]
	local direction = greater and 1 or -1
	local isX = axe == "X"

	local speed = direction * self.WalkSpeed * 10
	local velocity = Vector2.new(isX and speed, not isX and speed)
	self.Velocity += velocity

	return {
		active = true,
		greater = greater,
		velocity = velocity,
		name = axe,
	}
end

local function moveAxe(self, axe, target)
	local instance = self.Instance
	local velocity = self.Velocity

	local name = axe.name
	local axeVal = instance.Position
	axeVal = axeVal[name].Offset

	local isEnabled = check(axe.greater, target, axeVal)
	if isEnabled then
		isEnabled = self.Velocity[name] == velocity[name] and axe.active
	end

	if not isEnabled and axe.active then
		self.Velocity -= axe.velocity
		axe.active = false
	end

	return isEnabled
end

local function moveTo(self, target)
	local enabled = true
	self.Velocity = Vector2.zero

	local x = getAxeData(self, target, "X")
	local y = getAxeData(self, target, "Y")

	while enabled do
		local xActive = moveAxe(self, x, target.X)
		local yActive = moveAxe(self, y, target.Y)
		enabled = xActive or yActive
		task.wait()
	end
end

--[[={
	@desc Updates the amount of health of the character 
	@link void.link
}=]]

function methods:UpdateHealth(Health: number)
	assert(typeof(Health) == "number", ("Number expected got %s"):format(typeof(Health)))
	assert(Health <= self.MaxHealth, "The health cannot exceed maximum health")
	self.Health = Health

	if self.Health > 0 and Health <= 0 then
		self:Fire("Died")
	else
		self:Fire("HealthChanged")
	end
end

--[[={
	@desc The character jumps with the provided jump power, if none is provided it will use the JumpPower property as value 
	@link void.link
}=]]

function methods:Jump(jumpPower: number?)
	if not self.IsGrounded then
		return
	end

	jumpPower = (jumpPower or self.JumpPower) * 10
	coroutine.wrap(jump)(self, jumpPower)
end

--[[={
	@desc The character walks directly to the provided position
	@link void.link
}=]]

function methods:MoveTo(target: Vector2)
	coroutine.wrap(moveTo)(self, target)
end

--[[={
	@desc This class is used for the player character and for npcs
	@about
		@Health The amount of health of the character
		@MaxHealth The maximum amount of health of the character 
		@WalkSpeed The walk speed of the character
		@JumpPower The jump power of the character
}=]]

return sprite:Extend("Character", {
	methods = methods,
	readonly = {
		Health = 100,
	},
	rules = {
		MaxHealth = 100,
		WalkSpeed = 50,
		JumpPower = 250,
	},
})

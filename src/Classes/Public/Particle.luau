local tweenService = game:GetService("TweenService")
local upsideEngine = script.Parent.Parent.Parent
local sceneManager = require(upsideEngine.Services).SceneManager

local baseObject = require(upsideEngine.Classes.Internal.BaseObject)
local character = require(script.Parent.Character)
local staticObject = require(script.Parent.StaticObject)

local particle = {}
particle.__index = particle

function particle.new(): Particle
	local self = baseObject.new()
	self:SetClassName(script.Name)

	self.Angle = Vector2.new(90, 90)
	self.Info = TweenInfo.new(0.5)
	self.Enabled = true

	self.Rotation = 0
	self.MaxRate = 100
	self.Units = 0
	self.Range = 5
	self.LifeTime = 1
	self.Clock = 0
	self.Rate = 55

	self.Subject = character.new()
	self.Properties = {
		Image = "http://www.roblox.com/asset/?id=6904405933",
	}
	self.Goals = {
		Size = UDim2.fromScale(0.05, 0.1),
		ImageTransparency = 1,
	}

	return setmetatable(self, particle)
end

--[[={
    @desc Sets the subject property
}=]]
function particle:SetSubject(subject: Character)
	assert(subject ~= nil, "Subject expected")
	local newScene = sceneManager:Get(subject.Scene)
	assert(newScene ~= nil, "The subject must be in a scene!")

	local id = (self.Subject and self.Subject.Scene) or self.Scene
	local oldScene = sceneManager:Get(id)
	if self.Subject and oldScene then
		oldScene.ParticleEnvironment:RemoveOne(self.Id)
	end

	self.Subject = subject

	if not newScene.ParticleEnvironment:HasOne(self.Id) then
		newScene.ParticleEnvironment:AddOne(self, self.Id)
	end
end

--[[={
    @desc Sets the angle property of the particle
}=]]
function particle:SetAngle(Angle: Vector2)
	assert(Angle and Angle.X > 0 and Angle.Y > 0, "The angle components must be greater than 0!")
	self.Angle = Angle
end

--[[={
    @desc Sets the maximum amount of particles that can exist at the same time
}=]]
function particle:SetMaxRate(maxRate: number)
	assert(type(maxRate) == "number" and maxRate > 0, "The maxRate must be greater than 0!")
	assert(maxRate <= 1500, "The maxRate limit is 1500!")
	self.MaxRate = maxRate
end

function particle:SetRotation(rotation: number)
	assert(type(rotation) == "number", "Rotation must be a number (degrees)")
	self.Rotation = rotation
end

--[[={
    @desc Emits the specified amount of particles, if none is provided then will use as amount the Rate property
    @link void.link
}=]]
function particle:Emit(rate: number?)
	if not self.Enabled then
		return
	end

	local emitCount = rate or self.Rate
	if type(emitCount) ~= "number" or emitCount <= 0 then
		return
	end

	local id = (self.Subject and self.Subject.Scene) or self.Scene
	local scene = sceneManager:Get(id)
	if not scene or not scene.Instance or not scene.Instance.GameFrame then
		return
	end

	local available = math.max(self.MaxRate - self.Units, 0)
	if available <= 0 then
		return
	end

	emitCount = math.min(emitCount, available)
	for _ = 1, emitCount do
		self.Units += 1

		local unit = staticObject.new()
		unit.Instance.ZIndex = self.Instance.ZIndex

		local subjectInstance = (self.Subject and self.Subject.Instance) or unit.Instance
		local instance = unit.Instance
		instance.Parent = scene.Instance.GameFrame
		instance.Position = subjectInstance.Position

		for property, value in self.Properties do
			instance[property] = value
		end

		local halfAngleDeg = (self.Angle and self.Angle.X or 0) / 2

		local rotationOffset = tonumber(self.Rotation) or 0
		local thetaDeg = rotationOffset + ((math.random() * (2 * halfAngleDeg)) - halfAngleDeg)
		local theta = math.rad(thetaDeg)
		local radius = math.sqrt(math.random()) * self.Range

		local dx = math.cos(theta) * radius
		local dy = math.sin(theta) * radius
		if self.Angle and self.Angle.X and self.Angle.X ~= 0 then
			dy = dy * (self.Angle.Y / math.max(self.Angle.X, 1))
		end

		local targetPosition = subjectInstance.Position + UDim2.fromOffset(dx, dy)
		local info = TweenInfo.new(
			self.LifeTime,
			self.Info.EasingStyle,
			self.Info.EasingDirection,
			self.Info.RepeatCount,
			self.Info.Reverses,
			self.Info.DelayTime
		)

		local goalsTween = tweenService:Create(instance, info, self.Goals)
		local positionTween = tweenService:Create(instance, self.Info, {
			Position = targetPosition,
		})

		positionTween:Play()
		goalsTween:Play()

		local conn
		conn = goalsTween.Completed:Connect(function()
			if conn then
				conn:Disconnect()
			end
			pcall(function()
				goalsTween:Destroy()
				positionTween:Destroy()
				if unit and unit.Destroy then
					unit:Destroy()
				end
			end)
			self.Units -= 1
		end)

		task.wait(math.max(self.LifeTime / math.max(self.Rate, 1), 0.001))
	end
end

--[[={
	@desc 
		!!! warning 
			Currently it's recommended to use sprites to make particles/vfx, this class is in experimental state and can change a lot

		_____
		This class is used for vfx

	@about
		@Angle Depending on the value the particles will be more dispersed
		@Subject The subject which is going to be the center of emission of the particle, a character, sprite, etc...
		@MaxRate Is the maximum amount of particles that can exist at the same time
		@Units Is the amount of particles that are existing at this moment
		@Properties Is a table with the initial properties of the particle which is going to be generated
		@Goals Is a table with the goals of the particles
		@Info Is the tween info of the tween which is going to be used to move the particles
		@Enabled When its enabled new particles can be emitted
		@Range Is the distance that can be traveled by each particle 
		@LifeTime The number of seconds the particle will be active before being destroyed
		@Rate Is the amount of particles which is going to be generated
		@Clock Used for internal purposes
		@Rotation Rotation in degrees applied to the emission direction (offset for theta)
}=]]

return setmetatable(particle, baseObject)

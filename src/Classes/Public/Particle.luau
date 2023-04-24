local upsideEngine = script.Parent.Parent.Parent
local data = require(upsideEngine.AppData.Data)
local sceneManager = require(upsideEngine.Services).SceneManager

local baseObject = require(upsideEngine.Classes.Internal.BaseObject)
local light = require(upsideEngine.Classes.Public.Light)
local character = require(upsideEngine.Classes.Public.Character)

local tweenService = game:GetService("TweenService")
local restricted = data.restricted
local methods = {}

local function destroy(id, self, t1, t2, cn1, cn2)
	if cn1 then
		cn1:Disconnect()
		cn2:Disconnect()
	end

	t1:Destroy()
	t2:Destroy()

	self:Destroy()
	restricted[id].readonly.Units -= 1
end

--[[={
	@desc Sets the subject property
	@link void.link
}=]]

function methods:SetSubject(subject: Character)
	local sScene = sceneManager:Get(subject.Scene)
	assert(sScene ~= nil, "The subject must be in a scene!")

	local scene = sceneManager:Get(self.Subject.Scene)
	if self.Subject and scene then
		scene.ParticleEnvironment:RemoveOne(self.Id)
	end

	self.Subject = subject
	sScene.ParticleEnvironment:AddOne(self, self.Id)
end

--[[={
	@desc Sets the angle property of the particle
	@link void.link
}=]]

function methods:SetAngle(Angle: Vector2)
	assert(Angle.X > 0 and Angle.Y > 0, "The angle must be greater than 0!")
	self.Angle = Angle
end

--[[={
	@desc Sets the maximum amount of particles that can exist at the same time
	@link void.link
}=]]

function methods:SetMaxRate(maxRate: number)
	assert(maxRate > 0, "The maxRate must be greater than 0!")
	assert(maxRate <= 1500, "The maxRate limit is 1500!")
	self.MaxRate = maxRate
end

--[[={
	@desc Emits the specified amount of particles, if none is provided then will use as amount the Rate property
	@link void.link
}=]]

function methods:Emit(rate: number)
	local id = self.Subject and self.Subject.Scene or self.Scene
	local scene = sceneManager:Get(id)
	for _ = 1, self.Enabled and (rate or self.Rate) or 0 do
		if self.Units > self.MaxRate then
			break
		end

		local unit = light:new()
		unit.CollisionBlacklist[self.Subject.Id] = true
		unit.Track = self.TrackLight
		unit.Range = self.LightRange
		unit.Brightness = self.LightBrightness
		unit:Set(self.Properties)

		local subjectInstance = self.Subject.Instance
		local instance = unit.Instance
		instance.Parent = scene.Instance
		instance.Position = subjectInstance.Position

		local cn1, cn2 = nil, nil
		self.Units += 1

		local goalsTween = tweenService:Create(instance, self.Info, self.Goals)
		local positionTween = tweenService:Create(instance, self.Info, {
			Position = subjectInstance.Position + UDim2.fromOffset(
				math.random(-self.Angle.X, self.Angle.X) * self.Range,
				math.random(-self.Angle.Y, self.Angle.Y) * self.Range
			),
		})

		positionTween:Play()
		goalsTween:Play()
		task.delay(self.LifeTime, destroy, self.Id, unit, positionTween, goalsTween, cn1, cn2)

		task.wait(self.LifeTime / self.Rate)
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
		@TrackLight 
		!!! warning 
			Experimental, dont use
		@CanCollide 
		!!! warning 
			Experimental, dont use
		@LightBrightness 
		!!! warning 
			Experimental, dont use
		@LightRange 
		!!! warning 
			Experimental, dont use
}=]]

return baseObject:Extend(script.Name, {
	methods = methods,
	readonly = {
		Angle = Vector2.new(90, 90),
		InstanceType = "ImageLabel",
		Subject = character:new(),
		MaxRate = 100,
		Units = 0,
	},
	rules = {
		Properties = {
			Image = "http://www.roblox.com/asset/?id=6904405933",
		},
		Goals = {
			Size = UDim2.fromScale(0.05, 0.1),
			ImageTransparency = 1,
		},
		Info = TweenInfo.new(0.5),
		TrackLight = false, -- Experimental
		CanCollide = false,
		Enabled = true,
		LightBrightness = -10, -- Experimental
		LightRange = 150, -- Experimental
		Range = 5,
		LifeTime = 1,
		Clock = 0,
		Rate = 55,
	},
})

local upsideEngine = script.Parent.Parent.Parent

local setSmoothPosition = require(script.Parent.Parent.Parent.Lib.Util.Math.SetSmoothPosition)
local character = require(script.Parent.Parent.Public.Character)
local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)
local camera = {}
camera.__index = camera

--[[={
	@link Camera.md
}=]]

function camera.new(scene: Scene): Camera
	local self = eventEmitter.new()
	self:SetClassName(script.Name)
	self.OffsetPosition = UDim2.fromOffset(0, 0)
	self.LocalPosition = Vector2.zero
	self.Limits = Vector2.zero
	self.FollowSubject = true
	self.Scene = scene.Id
	self.Smoothness = 0.7
	self.Instance = scene.Instance:WaitForChild("GameFrame")
	self.Subject = character.new()

	return setmetatable(self, camera)
end

--[[={
	@desc Gets the camera position
	@link udim2.link
}=]]

function camera:GetPosition(): UDim2
	return self.Instance.Position
end

--[[={
	@desc Sets the camera position
	@link void.link
}=]]

function camera:SetPosition(udim2: UDim2)
	local position = udim2 + self.OffsetPosition
	self.LocalPosition = Vector2.new(udim2.X.Offset, udim2.Y.Offset)
	setSmoothPosition(self, self.Smoothness, position)
end

--[[={
	@desc Sets the camera subject
	@link void.link
}=]]

function camera:SetSubject(subject: Character)
	self.Subject = subject
end

--[[={
	@desc Position the camera in a centered location relative to the provided object
	@link void.link
}=]]

function camera:LookTo(object: StaticObject)
	assert(object:IsA("StaticObject"), ("StaticObject expected, got %s"):format(typeof(object)))
	local resolution = workspace.CurrentCamera.ViewportSize
	local center = resolution / 2

	local target = (object.Instance :: ImageLabel).Position
	target = Vector2.new(target.X.Offset, target.Y.Offset)

	local result = center + (center - target)
	self:SetPosition(UDim2.fromOffset(result.X, result.Y))
end

--[[={
	@desc This class is included on every scene, it's used to move you around the scene
	@about
		@Subject This property defines the object which is going to follow the camera
		@OffsetPosition This property serves to move as many pixels as you want the camera to adjust it to a desired position
		@LocalPosition This property is used to move the camera internally
		@Scene This is the Scene Id of the camera
		@Limits This property marks the limits to move the camera, for example, if you set `Vector2.new(0.5, 0.5)` the camera will move only when it reaches the limit
		@FollowSubject This property defines if the camera is going to follow the defined subject
		@Smoothness This property defines the smoothness with which the camera will move, it only works in a range between 0 and 1
}=]]

return setmetatable(camera, eventEmitter)

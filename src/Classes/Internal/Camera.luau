local upsideEngine = script.Parent.Parent.Parent

local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)
local character = require(upsideEngine.Classes.Public.Character)

local methods = {}
local constructor = {}

--[[={
	@link Camera.md
}=]]

function constructor:Camera(data: BaseObjectParams)
	local scene = data.Parent
	if not scene then
		return
	end

	addReadonly({ Scene = scene.Id, Instance = scene.Instance })
end

--[[={
	@desc Gets the camera position
	@link udim2.link
}=]]

function methods:GetPosition(): UDim2
	return self.Instance.Position
end

--[[={
	@desc Sets the camera position
	@link void.link
}=]]

function methods:SetPosition(udim2: UDim2)
	self.LocalPosition = Vector2.new(udim2.X.Offset, udim2.Y.Offset)
	self.Instance.Position = udim2
end

--[[={
	@desc Sets the camera subject
	@link void.link
}=]]

function methods:SetSubject(subject: Character)
	self.Subject = subject
end

function methods:LookTo(object: PhysicalObject)
	assert(object:IsA("PhysicalObject"), ("Physical Object expected, got%s"):format(typeof(object)))
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
		@LocalPosition This property is used to move the camera internally
		@Limits This property marks the limits to move the camera, for example, if you set `Vector2.new(0.5, 0.5)` the camera will move only when it reaches the limit
		@FollowSubject This property defines if the camera is going to follow the defined subject
}=]]

return eventEmitter:Extend(script.Name, {
	constructor = constructor,
	methods = methods,
	readonly = {
		Subject = character:new(),
	},
	rules = {
		LocalPosition = Vector2.zero,
		Limits = Vector2.zero,
		FollowSubject = true,
	},
})

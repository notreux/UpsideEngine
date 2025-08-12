local upsideEngine = script.Parent.Parent.Parent

local objectEnvironment = require(script.Parent.Parent.Internal.ObjectEnvironment)
local shaderEnvironment = require(script.Parent.Parent.Internal.ShaderEnvironment)
local camera = require(upsideEngine.Classes.Internal.Camera)
local baseObject = require(upsideEngine.Classes.Internal.BaseObject)

local soundEnvironment = require(upsideEngine.Classes.Internal.SoundEnvironment)
local lightingEnvironment = require(upsideEngine.Classes.Internal.LightingEnvironment)
local particleEnvironment = require(upsideEngine.Classes.Internal.ParticleEnvironment)

local sceneManager = require(upsideEngine.Services).SceneManager
local util = require(upsideEngine.Private.Util)

local scene = {}
scene.__index = scene

local function intersect(a, b, c, d)
	local r, s = (b - a), (d - c)
	d = r.X * s.Y - r.Y * s.X

	local u = ((c.X - a.X) * r.Y - (c.Y - a.Y) * r.X) / d
	local t = ((c.X - a.X) * s.Y - (c.Y - a.Y) * s.X) / d

	return (0 <= u and u <= 1 and 0 <= t and t <= 1) and a + t * r
end

--[[={
	@link Scene.md
}=]]

function scene.new(): Scene
	local self = baseObject.new("Folder")
	self:SetClassName(script.Name)

	local instance = self.Instance
	local gameFrame = Instance.new("Frame")
	gameFrame.Name = "GameFrame"
	gameFrame.Parent = instance
	gameFrame.BorderSizePixel = 0
	gameFrame.Size = UDim2.fromScale(1, 1)
	gameFrame.Position = UDim2.fromScale(0.5, 0.5)
	gameFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	gameFrame.BackgroundTransparency = 1

	self.Gravity = Vector2.new(0, 9.81 * 4)
	self.OnlyTrackVisible = false
	self.Camera = camera.new(self)
	self.LightingEnvironment = lightingEnvironment.new(self)
	self.ParticleEnvironment = particleEnvironment.new()
	self.SoundEnvironment = soundEnvironment.new()
	self.ShaderEnvironment = shaderEnvironment.new()
	self.Objects = objectEnvironment.new()

	sceneManager.Scenes[self.Id] = self
	self:On("Destroy", function()
		sceneManager.Scenes[self.Id] = nil
		sceneManager.ActiveScenes[self.Id] = nil
	end)

	return setmetatable(self, scene)
end

--[[={
	@desc Enables the scene, which will make it process physics, lights, sounds and sprites
	@link array.link
}=]]

function scene:Enable()
	local instance = self.Instance
	instance.GameFrame.Visible = true
	instance.Lighting.Visible = true

	sceneManager.ActiveScenes[self.Id] = self
	sceneManager:Fire("SceneLoaded", scene)
end

--[[={
	@desc Disables the scene
	@link array.link
}=]]

function scene:Disable()
	local instance = self.Instance
	instance.GameFrame.Visible = false
	instance.Lighting.Visible = false

	sceneManager.ActiveScenes[self.Id] = nil
	sceneManager:Fire("SceneUnloaded", scene)
end

--[[={
	@desc Gets all the objects with the provided tags in the scene
	@link array.link
}=]]

function scene:GetTaggedObjects(tag: string): Array<string>
	local Taggeds = {}

	for _, object in self.Objects do
		if object:HasTag(tag) then
			table.insert(Taggeds, object)
		end
	end

	return Taggeds
end

--[[={
	@desc Casts a ray using the Raycast2dParams. If it finds an elegible object a Raycast2dResult is returned containing the results of the operations
	@link /documentation/datatypes/Raycast2DResult.html
}=]]

function scene:Raycast(info: Raycast2dParams): Raycast2dResult
	local intersections = {}
	local isBlackList = info.FilterType == "Blacklist"
	local from, to = info.From, info.To
	info.List = info.List or {}

	for _, object in (isBlackList and self.Objects or info.List) do
		if isBlackList and info.List[object.Id] then
			continue
		end

		local instance = object.Instance
		local corners = util.GetCorners(instance)
		for i = 1, #corners do
			local prev = corners[i - 1] or corners[#corners]
			local nxt = corners[i + 1] or corners[1]
			local position = intersect(corners[i], nxt, from, to)

			if not position then
				continue
			end

			local normal = (corners[i] - prev).Unit
			table.insert(intersections, {
				Object = object,
				Position = UDim2.fromOffset(position.X, position.Y),
				Distance = (from - position).Magnitude,
				Normal = UDim2.fromOffset(normal.X, normal.Y),
			})
		end
	end

	table.sort(intersections, function(a, b)
		return a.Distance < b.Distance
	end)

	return intersections[1]
end

--[[={
	@desc This class is useful to have a workspace and manage your project more easily
	@about
		@OnlyTrackVisible This property defines whether physics should be calculated only for visible objects
		@Objects This environment stores all the objects in the scene
		@Camera The scene camera
		@Gravity The scene gravity
		@ParticleEnvironment This is the ParticleEnvironment of the scene
		@LightingEnvironment This is the LightingEnvironment of the scene
		@SoundEnvironment This is the SoundEnvironment of the scene
		@ShaderEnvironment This is the ShaderEnvironment of the scene
}=]]

return setmetatable(scene, baseObject)

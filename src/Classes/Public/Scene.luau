local upsideEngine = script.Parent.Parent.Parent

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

function scene.new(data: SceneParams): Scene
	local parent = data.Parent
	local isInstance = typeof(parent) == "Instance"
	local isLayerCollector = isInstance and parent:IsA("LayerCollector")

	local layerCollector = isLayerCollector and parent or Instance.new("ScreenGui")
	layerCollector.ZIndexBehavior = Enum.ZIndexBehavior.Global
	layerCollector.ResetOnSpawn = false

	local self = baseObject.new({
		Parent = data.Parent,
		InstanceType = "Frame",
	})

	self:SetClassName(script.Name)
	self.Objects = {}
	self.Camera = camera.new({ Parent = self })
	self.LightingEnvironment = lightingEnvironment.new({ Parent = self.Instance })
	self.ParticleEnvironment = particleEnvironment.new({ Parent = self.Instance })
	self.SoundEnvironment = soundEnvironment.new({ Parent = self.Instance })

	local instance = self.Instance
	instance.BorderSizePixel = 0
	instance.Size = UDim2.fromScale(1, 1)
	instance.Position = UDim2.fromScale(0.5, 0.5)
	instance.AnchorPoint = Vector2.new(0.5, 0.5)
	instance.BackgroundTransparency = 1
	instance.Parent = layerCollector

	if not isLayerCollector then
		layerCollector.Parent = isInstance and parent or game.StarterGui
	end

	if isInstance and layerCollector:IsA("ScreenGui") then
		layerCollector.IgnoreGuiInset = true
	end

	self:On("Destroy", function()
		sceneManager.Scenes[self.Id] = nil
		sceneManager.ActiveScenes[self.Id] = nil
	end)

	sceneManager.Scenes[self.Id] = self
	return setmetatable(self, scene)
end

--[[={
	@desc Adds the specified object
	@link void.link
}=]]

function scene:AddObject(object: BaseObject)
	local instance = object.Instance
	instance.Parent = self.Instance

	self.Objects[object.Id] = object
	object.Scene = self.Id
end

--[[={
	@desc Removes the specified object
	@link void.link
}=]]

function scene:RemoveObject(object: BaseObject)
	local instance = object.Instance
	instance.Parent = nil

	self.Objects[object.Id] = nil
	object.Scene = "SceneId"
end

--[[={
	@desc Finds an object by his name
	@link BaseObject.md
}=]]

function scene:FindByName(name: string): BaseObject?
	for _, object in self.Objects do
		if object.Name ~= name then
			continue
		end

		return object
	end

	return
end

--[[={
	@desc Checks if the object is in the scene
	@link boolean.link
}=]]

function scene:HasObject(object: BaseObject): boolean
	return self.Objects[object.Id] and true or false
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
		@Objects This table stores all the objects in the scene
		@SoundEnvironment This is the SoundEnvironment of the scene
		@ParticleEnvironment This is the ParticleEnvironment of the scene
		@LightingEnvironment This is the LightingEnvironment of the scene
}=]]

return setmetatable(scene, baseObject)

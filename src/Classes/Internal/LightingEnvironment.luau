local upsideEngine = script.Parent.Parent.Parent
local lightingSystem = upsideEngine.Systems.Lighting

local actor = require(script.Parent.Actor)
local actrees = require(script.Parent.Actrees)
local environment = require(upsideEngine.Classes.Public.Environment)

local lightingEnvironment = {}
lightingEnvironment.__index = lightingEnvironment

--[[={
	@link LightingEnvironment.md
}=]]

function lightingEnvironment.new(scene: Scene): LightingEnvironment
	local self = environment.new("Frame")
	self:SetClassName(script.Name)
	self.AmbientColor = Color3.fromRGB()
	self.AmbientTransparency = 0.2
	self.UpdateFrequency = 0.025
	self.LightIntensity = 1
	self.LightStyle = Enum.ResamplerMode.Pixelated
	self.ChunkColumns = 1
	self.ChunkResolution = Vector2.new(64, 64)
	self.__actrees = actrees.new()

	local gameFrame = scene.Instance:WaitForChild("GameFrame")
	local instance = self.Instance
	instance.Parent = gameFrame.Parent
	instance.Name = "Lighting"
	instance.Size = gameFrame.Size
	instance.Position = gameFrame.Position
	instance.AnchorPoint = gameFrame.AnchorPoint
	instance.BackgroundTransparency = 1

	return setmetatable(self, lightingEnvironment)
end

--[[={
	@desc Draws the pixels for the scene with the specified resolution
	@link void.link
}=]]

function lightingEnvironment:DrawPixels()
	local gameFrame = self.Instance.Parent:WaitForChild("GameFrame")
	local instance = self.Instance
	instance.Size = gameFrame.Size
	instance.Position = gameFrame.Position
	instance.AnchorPoint = gameFrame.AnchorPoint

	local chunkCols = self.ChunkColumns
	local chunkSize = self.Instance.AbsoluteSize.X / chunkCols

	local chunkX = math.clamp(self.ChunkResolution.X, 0, 128)
	local chunkY = math.clamp(self.ChunkResolution.Y, 0, 128)
	local chunkResolution = Vector2.new(chunkX, chunkY)

	local chunk = Instance.new("ImageLabel")
	chunk.Size = UDim2.fromOffset(chunkSize, chunkSize)
	chunk.BackgroundTransparency = 1
	chunk.BorderSizePixel = 0
	chunk.ZIndex = 1000
	chunk.ResampleMode = self.LightStyle

	for col = 0, chunkCols - 1 do
		local chkActor = actor.new(lightingSystem)
		self.__actrees:AddActor(chkActor)

		chkActor:SetVariable("pixels", {})
		chkActor:SetVariable("lights", {})
		chkActor:SetVariable("resolution", self.Instance.AbsoluteSize)
		chkActor:SetVariable("details", {
			col = col,
			chunk = chunk,
			chunkSize = chunkSize,
			chunkResolution = chunkResolution,
			screen = self.Instance,
			screenSize = self.Instance.AbsoluteSize,
		})
		chkActor:SetVariable("lighting", {
			ambientColor = self.AmbientColor,
			ambientTransparency = self.AmbientTransparency,
			updateFrequency = self.UpdateFrequency,
			lightIntensity = self.LightIntensity,
		})
	end

	task.wait(1)
	for _, chkActor in self.__actrees do
		chkActor:Execute("build")
		chkActor:ExecuteEveryStep("draw")
	end
end

--[[={
	@desc Updates the position, the transparency and the color of the ambient
	@link void.link
}=]]

function lightingEnvironment:UpdateScreen()
	local actree = self.__actrees
	actree:SetVariable("lighting", {
		ambientColor = self.AmbientColor,
		ambientTransparency = self.AmbientTransparency,
		updateFrequency = self.UpdateFrequency,
		lightIntensity = self.LightIntensity,
		lightStyle = self.LightStyle,
		chunkResolution = self.ChunkResolution,
	})

	for _, actor in self.__actrees do
		actor:Execute("updateScreen")
	end
end

--[[={
	@desc This class is one of the most important components of a scene, is used to manage everything related with the light 
	@about
		@AmbientColor This is the color of every pixel of the ambient, we can say is the darkness color
		@AmbientTransparency This is the transparency of the ambient, we can say is the darkness transparency
		@UpdateFrequency This is the seconds between every update of the pixels in the screen
		@LightIntensity This is the intensity for all the lights in the scene
		@LightStyle Determines the light rendering mode, there are two modes Enum.ResamplerMode.Pixelated and Enum.ResamplerMode.Default, the default value is Enum.ResamplerMode.Pixelated
		@ChunkResolution Determines the resolution for every chunk of the screen
		@ChunkColumns Determines the number of columns for the chunks, the number of rows is calculated automatically, the default value is 1
}=]]

return setmetatable(lightingEnvironment, environment)

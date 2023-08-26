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
	self.LightIntensity = 1.2
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
	@desc Draws the pixels for the scene with the specified pixel size
	@link void.link
}=]]

function lightingEnvironment:DrawPixels(pixelSize: number)
	if self.ready then
		return
	end

	local gameFrame = self.Instance.Parent:WaitForChild("GameFrame")
	local instance = self.Instance
	instance.Size = gameFrame.Size
	instance.Position = gameFrame.Position
	instance.AnchorPoint = gameFrame.AnchorPoint

	local size = math.clamp(pixelSize, 5, 50)
	local bigPixelSize = size * 10
	local bigPixel = Instance.new("Frame")
	bigPixel.Size = UDim2.fromOffset(bigPixelSize, bigPixelSize)
	bigPixel.BackgroundTransparency = self.AmbientTransparency
	bigPixel.BackgroundColor3 = self.AmbientColor
	bigPixel.BorderSizePixel = 0

	local canvas = Instance.new("Frame")
	canvas.Name = "Canvas"
	canvas.BackgroundTransparency = 1
	canvas.Parent = bigPixel
	canvas.Visible = false

	local pixel = Instance.new("Frame")
	pixel.Size = UDim2.fromOffset(size, size)
	pixel.BorderSizePixel = 0
	pixel.BackgroundTransparency = self.AmbientTransparency
	pixel.BackgroundColor3 = self.AmbientColor

	local iterations = bigPixelSize / size
	for x = 0, iterations - 1 do
		for y = 0, iterations - 1 do
			local px = pixel:Clone()
			px.Parent = canvas
			px.Position = UDim2.fromOffset(x * size, y * size)
		end
	end

	local xAxe = self.Instance.AbsoluteSize.X / bigPixelSize
	for x = 0, xAxe do
		local bpxActor = actor.new(lightingSystem)
		self.__actrees:AddActor(bpxActor)

		bpxActor:SetVariable("pixels", {})
		bpxActor:SetVariable("lights", {})
		bpxActor:SetVariable("resolution", self.Instance.AbsoluteSize)
		bpxActor:SetVariable("details", {
			x = x,
			bigPixel = bigPixel,
			bigPixelSize = bigPixelSize,
			canvas = canvas,
			screen = self.Instance,
			screenSize = self.Instance.AbsoluteSize,
		})
		bpxActor:SetVariable("lighting", {
			ambientColor = self.AmbientColor,
			ambientTransparency = self.AmbientTransparency,
			updateFrequency = self.UpdateFrequency,
			lightIntensity = self.LightIntensity,
		})

		bpxActor:Execute("build")
		bpxActor:ExecuteEveryStep("draw")
	end
end

--[[={
	@desc Updates the position, the transparency and the color of the ambient
	@link void.link
}=]]

function lightingEnvironment:UpdateScreen()
	for _, actor in self.__actrees do
		actor:SetVariable("lighting", {
			ambientColor = self.AmbientColor,
			ambientTransparency = self.AmbientTransparency,
			updateFrequency = self.UpdateFrequency,
			lightIntensity = self.LightIntensity,
		})
	end
end

--[[={
	@desc This class is one of the most important components of a scene, is used to manage everything related with the light 
	@about
		@AmbientColor This is the color of every pixel of the ambient, we can say is the darkness color
		@AmbientTransparency This is the transparency of the ambient, we can say is the darkness transparency
		@UpdateFrequency This is the seconds between every update of the pixels in the screen
		@LightIntensity This is the intensity for all the lights in the scene
}=]]

return setmetatable(lightingEnvironment, environment)

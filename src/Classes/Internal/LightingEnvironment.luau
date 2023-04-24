local upsideEngine = script.Parent.Parent.Parent
local environment = require(upsideEngine.Classes.Public.Environment)

local constructor = {}
local methods = {}

local function setProperty(i, p, v)
	i[p] = v
end

local function DrawLine(self, x, info)
	local sx = x * info.size
	local iterations = info.pixelsPerLine - info.pixelsPerLargePixel

	for y = 0, iterations, info.pixelsPerLargePixel do
		local copy = info.largePixel:Clone()
		local pxY = y / info.pixelsPerLargePixel * 0.1

		local childs, data = copy:GetChildren(), {}
		for i, pixel in ipairs(childs) do
			pixel.Position = UDim2.fromScale(sx, pxY + (info.size * i))
			pixel.Archivable = false
			table.insert(data, { instance = pixel, absolutePosition = Vector2.zero })
		end

		setProperty(copy, "Parent", info.parent)
		table.insert(self.Pixels, data)
		task.wait()
	end

	if self.ready then
		return
	end

	self.ready = true
	self:UpdateScreen()
end

--[[={
	@link LightingEnvironment.md
}=]]

function constructor:ZLightingEnvironment(parent: Frame)
	if not parent then
		return
	end

	local instance = self.Instance
	instance.Parent = parent.Parent
	instance.Name = "Lighting"
	instance.Size = parent.Size
	instance.Position = parent.Position
	instance.AnchorPoint = parent.AnchorPoint
	instance.BackgroundTransparency = 1
end

--[[={
	@desc Draws the pixels for the scene with the specified settings
	```lua
		settings = {
			Pixels = 800, -- We can say that is the resolution for the ambient, is limited to 2000
			Resolution = Vector2.new(1080, 1920) -- Defines the resolution to take as reference, is going to use the screen resolution if none is specified
			AutoScale = true -- Defines if the amount of pixels is going to be scaled depending on the resolution
		}
	```
	@link void.link
}=]]

function methods:DrawPixels(settings: any)
	if self.ready then
		return
	end

	local resolution = settings.Resolution or workspace.CurrentCamera.ViewportSize
	local pixels = settings.AutoScale and settings.Pixels * resolution.Y / 1000 or settings.Pixels
	pixels = math.clamp(math.round(pixels / 100) * 100, 100, 1500)

	local largePixel = Instance.new("Folder")
	local info = {
		pixels = pixels,
		size = 10 / pixels,
		largePixel = largePixel,
		parent = self.Instance,
		pixelsPerLine = pixels * 0.1,
		pixelsPerLargePixel = pixels * 0.01,
	}

	self.PixelIndex = math.round(info.pixelsPerLargePixel * 0.5)
	self.Distance = info.pixelsPerLargePixel * 20
	self.Distance *= self.Distance

	for _ = 1, info.pixelsPerLargePixel do
		local pixel = Instance.new("Frame")
		pixel.AutoLocalize = false
		pixel.ZIndex = 100
		pixel.AnchorPoint = Vector2.new(0.5, 1)
		pixel.BorderSizePixel = 0
		pixel.BackgroundColor3 = self.AmbientColor or Color3.fromRGB(0, 0, 0)
		pixel.BackgroundTransparency = self.AmbientTransparency
		pixel.Size = UDim2.fromScale(info.size, info.size)
		pixel.Parent = largePixel
	end

	for x = 0, info.pixelsPerLine do
		coroutine.wrap(DrawLine)(self, x, info)
	end
end

--[[={
	@desc Sets the base intensity for all the lights in the scene
	@link void.link
}=]]

function methods:SetLightingIntensity(value: number)
	assert(value >= 0 and value <= 1, "The lighting intensity must be between 0 and 1")
	self.LightingIntensity = (1.1 - value) / 1e5
end

--[[={
	@desc Gets the base intensity for all the lights in the scene 
	@link number.link
}=]]

function methods:GetLightingIntensity(): number
	return self.LightingIntensity * 1e5 - 0.1
end

--[[={
	@desc Updates the position, the transparency and the color of the ambient
	@link void.link
}=]]

function methods:UpdateScreen()
	for _, largePixel in self.Pixels do
		for _, pixel in largePixel do
			local instance = pixel.instance
			instance.BackgroundColor3 = self.AmbientColor
			pixel.absolutePosition = instance.AbsolutePosition
			pixel.transparency = self.AmbientTransparency
		end
	end
end

--[[={
	@desc This class is one of the most important components of a scene, is used to manage everything related with the light 
	@about
		@AmbientColor This is the color of every pixel of the ambient, we can say is the darkness color
		@AmbientTransparency This is the transparency of the ambient, we can say is the darkness transparency
		@UpdateFrequency This is the seconds between every update of the pixels in the screen
		@LightIntensity This is the base intensity for all the lights in the scene
		@Pixels Stores all the ambient pixels
		@PixelIndex This is the pixel in the middle of every large pixel, used for internal purposes
		@Distance This is the distance between every large pixel, used for internal purposes
}=]]

return environment:Extend(script.Name, {
	constructors = constructor,
	methods = methods,
	rules = {
		AmbientColor = Color3.fromRGB(),
		AmbientTransparency = 0.02,
		UpdateFrequency = 0.025,
		PixelIndex = 0,
		Distance = 0,
	},
	readonly = {
		InstanceType = "Frame",
		Pixels = {},
		LightingIntensity = 5e-6,
	},
	private = {
		ready = false,
	},
})

local baseObject = require(script.Parent.Parent.Internal.BaseObject)
local toUDim2 = require(script.Parent.Parent.Parent.Private.Util.DataType.ToUDim2)
local parallax = {}
parallax.__index = parallax

function parallax.new()
	local self = baseObject.new("Frame")
	self:SetClassName(script.Name)
	self.CanvasSize = Vector2.new(1, 1)
	self.Offset = Vector2.zero
	self.Track = true
	self.LockToCamera = false
	self.Instance.ClipsDescendants = true
	self.Instance.AnchorPoint = Vector2.new(0.5, 0.5)

	local content = Instance.new("ImageLabel")
	content.Name = "Content"
	content.BackgroundTransparency = 1
	content.AnchorPoint = Vector2.new(0.5, 0.5)
	content.Position = UDim2.fromScale(0.5, 0.5)
	content.Size = UDim2.fromScale(3, 3)
	content.TileSize = UDim2.fromScale(1, 1)
	content.ScaleType = Enum.ScaleType.Tile
	content.ResampleMode = Enum.ResamplerMode.Pixelated
	content.Parent = self.Instance
	content.ZIndex = -1

	return setmetatable(self, parallax)
end

--[[={
	@desc Sets the tile texture
	@link void.link
}=]]

function parallax:SetTexture(texture)
	self.Instance.Content.Image = texture
end

--[[={
	@desc Updates the parallax properties (position, canvasSize, etc.), its automatically called when Track is enabled
	@link void.link
}=]]

function parallax:UpdateTiles()
	local instance = self.Instance :: ImageLabel
	local content = instance.Content :: ImageLabel
	local absoluteSize = instance.AbsoluteSize

	local canvasSize = absoluteSize * self.CanvasSize
	local position = self.Offset / absoluteSize
	local finalPosition = {
		X = 0,
		Y = 0,
	} :: any

	for axe in finalPosition do
		local value = tostring(position[axe])
		value = value:split(".")[2] or "0"
		value = tonumber("0." .. value)

		finalPosition[axe] = position[axe] < 0 and value or -value
	end

	finalPosition = Vector2.new(finalPosition.X, finalPosition.Y)
	content.TileSize = toUDim2(canvasSize)
	content.Position = toUDim2(finalPosition * absoluteSize) + UDim2.fromScale(0.5, 0.5)
end

--[[={
	@desc This class is used to create inmersive backgrounds
	@about
		@CanvasSize Defines the image zoom, if the value is 1X, 1Y it will see the whole image as expected, if you set it to 2X, 2Y you only will be able see half of the image
		@Offset Defines the scroll position of the parallax object
		@Track Defines if Update method should be called automatically
}=]]

return setmetatable(parallax, baseObject)

--!native
local path = require(script.Parent.Parent.Private.Util.Internal.Path)
local isOutScreen = require(script.Parent.Parent.Private.Util.Math.IsOutScreen)

local assetService = game:GetService("AssetService")
local shadingSystem = {}
local cache = {}

local function loadImage(id)
	local sucess, imageData = nil, nil
	for retries = 1, 10 do
		sucess, imageData = pcall(assetService.CreateEditableImageAsync, assetService, id)

		if sucess then
			cache[id] = imageData
			return imageData
		end
	end

	return Instance.new("EditableImage")
end

function shadingSystem.onSetData(data, name, value)
	local result = {}
	for index, object in value do
		local instance = object.Instance
		local old = (data[name] or data)[index]

		local isEqual = old and old.Image == instance.Image
		local outScreen = isOutScreen(instance.AbsolutePosition, instance.AbsoluteSize)

		if (outScreen or isEqual) and old then
			old.Track = not outScreen
			result[index] = old
			continue
		end

		local shaderSource = path.readRoute(object.Shader.Path)
		local shadingFunction = require(shaderSource)
		local rectSize = instance.ImageRectSize

		local id = instance.Image
		local imageData = cache[id] or loadImage(id)
		local canvas = instance:FindFirstChild("Canvas")

		if not canvas then
			canvas = imageData:Clone()
			canvas.Parent = instance
			canvas.Name = "Canvas"
		end

		canvas:Resize(imageData.Size)
		rectSize = Vector2.new(
			math.clamp(math.floor(rectSize.X) + 1, 0, imageData.Size.X),
			math.clamp(math.floor(rectSize.Y) + 1, 0, imageData.Size.Y)
		)

		result[index] = {
			RectSize = if rectSize.X > 1 then rectSize else canvas.Size,
			Instance = object.Instance,
			Shader = object.Shader,
			Run = shadingFunction,
			Canvas = canvas,
			ImageData = imageData,
			Image = id,
			Track = true,
			Enabled = object.Shader.Enabled,
		}
	end

	return result
end

function shadingSystem.draw(details)
	local shaders = details.shadable
	local shaderResults = {}

	for _, shader in shaders do
		local instance = shader.Instance
		if not shader.Track or not shader.Enabled then
			continue
		end

		local canvas = shader.Canvas :: EditableImage
		local run = shader.Run

		local size = canvas.Size
		local rectSize = shader.RectSize

		local position = instance.ImageRectOffset
		local area = position + rectSize

		if size.X < area.X or size.Y < area.Y then
			continue
		end

		local pixels = table.create(math.round(rectSize.X * rectSize.Y * 4))
		local bmp = shader.ImageData:ReadPixels(position, rectSize)

		for iteration = 0, rectSize.X * rectSize.Y - 1 do
			local i = 1 + (iteration * 4)
			local r, g, b, a = bmp[i], bmp[i + 1], bmp[i + 2], bmp[i + 3]
			r, g, b, a = run(r, g, b, a)

			pixels[i] = r
			pixels[i + 1] = g
			pixels[i + 2] = b
			pixels[i + 3] = a
		end

		shaderResults[canvas] = {
			position = position,
			rectSize = rectSize,
			pixels = pixels,
		}
	end

	task.synchronize()
	for canvas, data in shaderResults do
		canvas:WritePixels(data.position, data.rectSize, data.pixels)
	end
end

return shadingSystem

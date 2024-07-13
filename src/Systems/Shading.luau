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

local function getPixel(bmp, idx)
	return bmp[idx], bmp[idx + 1], bmp[idx + 2], bmp[idx + 3]
end

local function isEmpty(pixels, iterations, position)
	local x = position.X
	local y = position.Y
	local width = iterations.X + 1

	if x < 0 or x > iterations.X or y < 0 or y > iterations.Y then
		return true
	end

	local index = 1 + ((y * width) + x) * 4
	local result = pixels[index + 3] == 0

	return result
end

local function getAproximatedColor(pixels, position, iterations)
	local count = 0
	local sumR, sumG, sumB, sumA = 0, 0, 0, 0
	local width = iterations.X + 1

	for sx = -1, 1 do
		for sy = -1, 1 do
			local nx = position.X + sx
			local ny = position.Y + sy
			local nPosition = Vector3.new(nx, ny)

			if isEmpty(pixels, iterations, nPosition) then
				continue
			end

			local index = 1 + ((ny * width) + nx) * 4
			local r, g, b, a = getPixel(pixels, index)
			sumR += r
			sumG += g
			sumB += b
			sumA += a
			count += 1
		end
	end

	return sumR / count, sumG / count, sumB / count, sumA / count
end

local function countPaintedNeighbors(pixels, iterations, position)
	local count = 0
	local range = 2

	for sx = -range, range do
		for sy = -range, range do
			local nx = position.X + sx
			local ny = position.Y + sy
			local nPosition = Vector3.new(nx, ny)

			if isEmpty(pixels, iterations, nPosition) then
				continue
			end

			count += 1
		end
	end

	return count
end

local function scanGaps(pixels, iterations, width)
	for y = 0, iterations.Y do
		for x = 0, iterations.X do
			local idx = 1 + ((y * width) + x) * 4
			if pixels[idx + 3] ~= 0 then
				continue
			end

			local position = Vector3.new(x, y)
			local count = countPaintedNeighbors(pixels, iterations, position)

			if count < 11 then
				continue
			end

			local r, g, b, a = getAproximatedColor(pixels, position, iterations)
			pixels[idx] = r
			pixels[idx + 1] = g
			pixels[idx + 2] = b
			pixels[idx + 3] = a
		end
	end
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

		local pixels = table.create(math.round(rectSize.X * rectSize.Y * 4), 0)
		local bmp = shader.ImageData:ReadPixels(position, rectSize)

		local iterations = Vector3.new(rectSize.X - 1, rectSize.Y - 1)
		local width, checkGaps = rectSize.X, false

		for y = 0, iterations.Y do
			for x = 0, iterations.X do
				local idx = 1 + ((y * width) + x) * 4
				local sx, sy

				local r, g, b, a = getPixel(bmp, idx)
				sx, sy, r, g, b, a = run(x, y, r, g, b, a)

				sx = math.floor(sx)
				sy = math.floor(sy)

				if sx < 0 or sx > iterations.X or sy < 0 or sy > iterations.Y then
					continue
				end

				checkGaps = checkGaps or sx ~= x or sy ~= y
				idx = 1 + ((sy * rectSize.X) + sx) * 4

				pixels[idx] = r
				pixels[idx + 1] = g
				pixels[idx + 2] = b
				pixels[idx + 3] = a
			end
		end

		if checkGaps then
			scanGaps(pixels, iterations, width)
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

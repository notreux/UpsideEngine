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

local function getPixel(bmp, idx)
	return bmp[idx] or 0, bmp[idx + 1] or 0, bmp[idx + 2] or 0, bmp[idx + 3] or 0
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

local function scanGaps(pixels, iterations, preicision)
	local width = iterations.X + 1
	preicision = preicision * 16

	for y = 0, iterations.Y do
		for x = 0, iterations.X do
			local idx = 1 + ((y * width) + x) * 4
			if pixels[idx + 3] ~= 0 then
				continue
			end

			local position = Vector3.new(x, y)
			local count = countPaintedNeighbors(pixels, iterations, position)

			if count < preicision then
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

local function texture(imageLabel: ImageLabel, position: Vector2 | Vector3)
	local id = imageLabel.Image
	local canvas = cache[id]

	if not canvas then
		task.synchronize()
		canvas = loadImage(id)
		task.desynchronize()
	end

	local size = canvas.Size
	local offset = imageLabel.ImageRectOffset
	local rectSize = imageLabel.ImageRectSize
	rectSize = if rectSize.X ~= 0 then rectSize else size
	rectSize = Vector2.new(
		math.round(math.min(size.X - offset.X, rectSize.X)),
		math.round(math.min(size.Y - offset.Y, rectSize.Y))
	)

	local x = math.floor(position.X - offset.X)
	local y = math.floor(position.Y - offset.Y)

	if x < 0 or x >= rectSize.X or y < 0 or y >= rectSize.Y then
		return 0, 0, 0, 0
	end

	local bmp = canvas:ReadPixels(offset, rectSize)
	local idx = 1 + ((y * rectSize.X) + x) * 4

	return getPixel(bmp, idx)
end

local function rotate(centre, position, degrees)
	local rotation = math.rad(degrees)
	local sin, cos = math.sin(rotation), math.cos(rotation)

	local XDistance = position.X - centre.X
	local YDistance = position.Y - centre.Y

	local x = centre.X + XDistance * cos - YDistance * sin
	local y = centre.Y + XDistance * sin + YDistance * cos

	return x, y
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
			math.clamp(math.round(rectSize.X), 0, imageData.Size.X),
			math.clamp(math.round(rectSize.Y), 0, imageData.Size.Y)
		)

		local env = getfenv(shadingFunction)
		env.texture = texture
		env.rotate = rotate

		setfenv(shadingFunction, env)
		result[index] = {
			RectSize = if rectSize.X > 1 then rectSize else canvas.Size,
			Instance = object.Instance,
			Shader = object.Shader,
			Precision = object.Shader.Precision,
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
		if size.X < position.X or size.Y < position.Y then
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
				local env = getfenv(run)
				env.opacity = a
				env.red = r
				env.green = g
				env.blue = b
				env.x = x
				env.y = y

				setfenv(run, env)
				run(x, y, r, g, b, a)
				env = getfenv(run)

				sx = math.floor(env.x)
				sy = math.floor(env.y)
				r = env.red
				g = env.green
				b = env.blue
				a = env.opacity

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
			scanGaps(pixels, iterations, shader.Precision)
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

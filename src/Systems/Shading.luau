local path = require(script.Parent.Parent.Private.Util.Internal.Path)
local isOutScreen = require(script.Parent.Parent.Private.Util.Math.IsOutScreen)

local Canvas2d = require(script.Parent.Parent.Private.Util.Graphics.Canvas2d)
local ContentManager = require(script.Parent.Parent.Private.Util.Graphics.ContentManager)
local shadingSystem = {}

@native
local function clampV2(base, max)
	return Vector2.new(
		math.clamp(math.round(base.X), 0, max.X), -- X
		math.clamp(math.round(base.Y), 0, max.Y) -- Y
	)
end

@native
local function getPixel(bmp, idx)
	return buffer.readu8(bmp, idx) or 0,
		buffer.readu8(bmp, idx + 1) or 0,
		buffer.readu8(bmp, idx + 2) or 0,
		buffer.readu8(bmp, idx + 3) or 0
end

@native
local function isEmpty(pixels, iterations, position)
	local x = position.X
	local y = position.Y
	local width = iterations.X + 1

	if x < 0 or x > iterations.X or y < 0 or y > iterations.Y then
		return true
	end

	local index = ((y * width) + x) * 4
	local result = buffer.readu8(pixels, index + 3) == 0

	return result
end

@native
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

			local index = ((ny * width) + nx) * 4
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

@native
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

@native
local function scanGaps(pixels, iterations, preicision)
	local width = iterations.X + 1
	preicision = preicision * 16

	for y = 0, iterations.Y do
		for x = 0, iterations.X do
			local idx = ((y * width) + x) * 4
			if buffer.readu8(pixels, idx + 3) ~= 0 then
				continue
			end

			local position = Vector3.new(x, y)
			local count = countPaintedNeighbors(pixels, iterations, position)

			if count < preicision then
				continue
			end

			local r, g, b, a = getAproximatedColor(pixels, position, iterations)
			buffer.writeu8(pixels, idx, r)
			buffer.writeu8(pixels, idx + 1, g)
			buffer.writeu8(pixels, idx + 2, b)
			buffer.writeu8(pixels, idx + 3, a)
		end
	end
end

@native
local function texture(imageLabel: ImageLabel, position: Vector2 | Vector3)
	local id = imageLabel.Image
	local canvas = ContentManager.cache[id]

	if not canvas and imageLabel.ImageContent.Uri then
		task.synchronize()
		canvas = ContentManager.loadImage(id)
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

	local bmp = canvas:ReadPixelsBuffer(offset, rectSize)
	local idx = ((y * rectSize.X) + x) * 4

	return getPixel(bmp, idx)
end

@native
local function rotate(centre, position, degrees)
	local rotation = math.rad(degrees)
	local sin, cos = math.sin(rotation), math.cos(rotation)

	local XDistance = position.X - centre.X
	local YDistance = position.Y - centre.Y

	local x = centre.X + XDistance * cos - YDistance * sin
	local y = centre.Y + XDistance * sin + YDistance * cos

	return x, y
end

local function isOutsideBounds(size, cropArea)
	return size.X < cropArea.X or size.Y < cropArea.Y
end

local function shouldSkip(object, old, id)
	local oldCanvas: Canvas2d.canvas2d = old.Canvas
	local playingSprite = object.Sprites and object.Sprites[object.Active.Name]
	local isContainerAdded = oldCanvas and oldCanvas:hasContainer(object.Instance)
	
	local sameSize = oldCanvas and oldCanvas.image and oldCanvas.image.Size == old.ImageData.Size
	local sameUrl = if playingSprite and oldCanvas then playingSprite.Url == oldCanvas.url 
				elseif oldCanvas then oldCanvas.url == id
				else nil

	return (sameUrl and sameSize) and isContainerAdded and oldCanvas
end

function shadingSystem.onSetData(data, name, value)
	local oldValue = data[name]
	local result = {}

	for idx, object in value do
		local shader = object.Shader
		local mirrorSource = shader.MirrorSource
		local useMirror = shader.MirrorEnabled and mirrorSource ~= nil

		local index = if useMirror then shader.Id else idx 
		local instance: ImageLabel = if useMirror then mirrorSource else object.Instance
		local old = oldValue[index] or {}

		local outScreen = isOutScreen(instance.AbsolutePosition, instance.AbsoluteSize)
		local id = instance:GetAttribute("url")
		id = if id ~= nil then id else instance.Image 

		if outScreen and shouldSkip(object, old, id) then
			old.Track = not outScreen
			result[index] = old
			continue
		end

		local shaderSource = path.readRoute(object.Shader.Path)
		local shadingFunction = require(shaderSource)

		local imageData = ContentManager.loadImage(id)
		local canvas = old.Canvas or Canvas2d.new()
		canvas:addContainer(object.Instance)
		canvas:setPrimaryContainer(instance)

		if shader.PreloadSprites and object.Sprites then
			canvas:preloadSprites(object.Sprites)
		end

		if id ~= "" and canvas.url ~= id then
			canvas:setUrl(id)
			instance:SetAttribute("url", id)
		end

		result[index] = {
			Instance = instance,
			Shader = shader,
			Precision = shader.Precision,
			Run = shadingFunction,
			Canvas = canvas,
			ImageData = imageData,
			Image = id,
			Track = true,
			Enabled = shader.Enabled,
		}
	end

	return result
end

@native
function shadingSystem.draw(details)
	local shadable = details.shadable or {}
	local shaderResults = {}

	for _, data in shadable do
		local canvas = data.Canvas :: Canvas2d.canvas2d
		local skipProcess = not data.Track or not data.Enabled
		local isLoading = not data.ImageData or not data.Canvas.image

		if skipProcess or isLoading then
			continue
		end

		local instance = canvas.primaryContainer
		local run = data.Run

		local sourceSize = data.ImageData.Size
		local canvasSize = canvas.image.Size

		local rectSize = clampV2(instance.ImageRectSize, canvasSize)
		local position = clampV2(instance.ImageRectOffset, canvasSize)

		local cropSize = if rectSize.X > 0 then rectSize else canvasSize
		local cropArea = position + cropSize

		if isOutsideBounds(sourceSize, cropArea) then
			continue
		end
		
		local pixels = buffer.create(cropSize.X * cropSize.Y * 4)
		local bmp = data.ImageData:ReadPixelsBuffer(position, cropSize)

		local iterations = Vector3.new(cropSize.X - 1, cropSize.Y - 1)
		local width, checkGaps = cropSize.X, false

		local shaderData = {
			x = 0,
			y = 0,
			red = 0,
			green = 0,
			blue = 0,
			opacity = 0,
			rotate = rotate,
			texture = texture,
		}

		for y = 0, iterations.Y do
			for x = 0, iterations.X do
				local idx = ((y * width) + x) * 4
				local sx, sy

				local r, g, b, a = getPixel(bmp, idx)
				shaderData.red = r
				shaderData.green = g
				shaderData.blue = b
				shaderData.opacity = a
				shaderData.x = x
				shaderData.y = y

				run(shaderData)
				sx = math.floor(shaderData.x)
				sy = math.floor(shaderData.y)

				if sx < 0 or sx > iterations.X or sy < 0 or sy > iterations.Y then
					continue
				end

				checkGaps = checkGaps or sx ~= x or sy ~= y
				idx = ((sy * cropSize.X) + sx) * 4

				buffer.writeu8(pixels, idx, shaderData.red or r)
				buffer.writeu8(pixels, idx + 1, shaderData.green or g)
				buffer.writeu8(pixels, idx + 2, shaderData.blue or b)
				buffer.writeu8(pixels, idx + 3, shaderData.opacity or a)
			end
		end

		if checkGaps then
			scanGaps(pixels, iterations, data.Precision)
		end

		shaderResults[canvas] = {
			i = instance,
			position = position,
			cropSize = cropSize,
			pixels = pixels,
		}
	end

	task.synchronize()
	for canvas, data in shaderResults do
		local cropArea = data.cropSize + data.position
		local image = canvas.image
		
		if isOutsideBounds(image.Size, cropArea) then
			continue
		end

		image:WritePixelsBuffer(data.position, data.cropSize, data.pixels)
	end
end

return shadingSystem

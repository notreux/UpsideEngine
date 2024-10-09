--!native
local getDistance = require(script.Parent.Parent.Private.Util.Math.GetDistance)
local normalize = require(script.Parent.Parent.Private.Util.Math.Normalize)
local IsOutScreen = require(script.Parent.Parent.Private.Util).IsOutScreen
local clock = os.clock
local ms = clock()
local axes = {
	Vector3.zero,
	Vector3.new(0, 1),
	Vector3.new(1, 0),
	Vector3.new(1, 1),
}

local function lerpColor(color1, color2, factor)
	return Color3.new(
		color1.R * (1 - factor) + color2.R * factor,
		color1.G * (1 - factor) + color2.G * factor,
		color1.B * (1 - factor) + color2.B * factor
	)
end

local function sortf(l1, l2)
	return l1.range > l2.range
end

local function isBallInsidechunk(chk, light, range)
	return chk.position.X < light.Position.X + range
		and chk.position.X + chk.size.X > light.Position.X - range
		and chk.position.Y < light.Position.Y + range
		and chk.position.Y + chk.size.Y > light.Position.Y - range
end


--stylua: ignore start
local function normalizeAngle(angle)
	local normalized = angle % (2 * math.pi)
	return normalized > math.pi 
		and normalized - 2 * math.pi 
		or normalized 
end
--stylua: ignore end

local function getRotatedAngle(light, origin)
	local dx = origin.X - light.Position.X
	local dy = origin.Y - light.Position.Y

	local angle = math.atan2(dy, dx)
	local rotatedAngle = angle - light.Rotation

	return normalizeAngle(rotatedAngle)
end

local function isSpotInsidechunk(chk, light, range)
	local lightAngle = math.clamp(light.Angle, 60, 360)
	for _, axe in axes do
		local position = chk.position + chk.size * axe
		local rotatedAngle = getRotatedAngle(light, position)

		local insideAngle = -lightAngle <= rotatedAngle and rotatedAngle <= lightAngle
		local insideRange = getDistance(position, light.Position + light.Size * 0.5) < light.AbsoluteRange * 1.6

		if insideAngle and insideRange then
			return true
		end
	end

	return false
end

local function drawSpotLight(chkData, light, staticData)
	local ambientTransparency = staticData.ambientTransparency
	local absRange = light.AbsoluteRange
	local angle = light.Angle * 0.5

	if not isSpotInsidechunk(chkData, light, light.Range) then
		return
	end

	local pixelCount = #chkData.content - 1
	for i = 0, pixelCount do
		local px = chkData.content[i + 1]
		local position = px.position

		local distance = getDistance(position, light.Position + light.Size * 0.5)
		local rotatedAngle = getRotatedAngle(light, position)

		if distance > absRange or (rotatedAngle <= -angle or rotatedAngle >= angle) then
			continue
		end

		local color = px.color
		local transparency = px.transparency or ambientTransparency

		local nDistance = if light.Inverted then normalize(distance, 0, absRange) else math.log(distance, absRange)
		local pastDistance = px.pastDistance or nDistance

		local influence1 = math.clamp(1 - (distance / absRange) ^ 2, 0, 1)
		local influence2 = math.clamp(1 - (pastDistance / absRange) ^ 2, 0, 1)
		local totalInfluence = influence1 + influence2

		local newTransparency = transparency - nDistance + light.Brightness + 1
		local mixFactor = 1 - influence2 / totalInfluence
		local newColor = if color then lerpColor(color, light.Color, mixFactor) else light.Color

		px.pastDistance = distance
		px.transparency = newTransparency
		px.color = newColor
	end
end

local function drawPointLight(chkData, light, staticData)
	local ambientTransparency = staticData.ambientTransparency
	local absRange = light.AbsoluteRange

	if not isBallInsidechunk(chkData, light, light.Range) then
		return
	end

	local pixelCount = #chkData.content - 1
	for i = 0, pixelCount do
		local px = chkData.content[i + 1]
		local position = px.position

		local distance = getDistance(position, light.Position)
		if distance > absRange then
			continue
		end

		local color = px.color
		local transparency = px.transparency or ambientTransparency

		local nDistance = if light.Inverted then normalize(distance, 0, absRange) else math.log(distance, absRange)
		local pastDistance = px.pastDistance or nDistance
		local newTransparency = transparency - nDistance + light.Brightness + 1

		local influence1 = math.clamp(1 - (distance / absRange) ^ 2, 0, 1)
		local influence2 = math.clamp(1 - (pastDistance / absRange) ^ 2, 0, 1)
		local totalInfluence = influence1 + influence2

		local mixFactor = 1 - influence2 / totalInfluence
		local newColor = if color then lerpColor(color, light.Color, mixFactor) else light.Color

		px.pastDistance = distance
		px.transparency = newTransparency
		px.color = newColor
	end
end

local function buildCanvas(chunk, position, size)
	local canvas = chunk.Canvas.Size
	local pixels = table.create((canvas.Y - 1) * (canvas.X - 1))

	for y = 0, canvas.Y - 1 do
		for x = 0, canvas.X - 1 do
			local normalPosition = Vector3.new(x / canvas.X, y / canvas.Y)
			table.insert(pixels, {
				position = position + normalPosition * size,
			})
		end
	end

	return pixels
end

local function serializeChunk(chunks, chkData, lighting)
	local canvas = chkData.canvas.Size
	local bufferSize = canvas.Y * canvas.X

	local pxIndex = 0
	local chkPixels = buffer.create(bufferSize * 4)
	chunks[chkData] = chkPixels

	for _, px in chkData.content do
		local isDrawn = px.transparency ~= 0 and px.transparency ~= nil
		local transparency = if isDrawn
			then math.clamp(px.transparency, lighting.ambientTransparency, 1)
			else lighting.ambientTransparency

		local color = if isDrawn
			then lerpColor(
				px.color,
				lighting.ambientColor,
				math.clamp(lighting.lightIntensity - px.transparency, 0, lighting.lightIntensity)
			)
			else lighting.ambientColor

		buffer.writeu8(chkPixels, pxIndex, color.R * 255)
		buffer.writeu8(chkPixels, pxIndex + 1, color.G * 255)
		buffer.writeu8(chkPixels, pxIndex + 2, color.B * 255)
		buffer.writeu8(chkPixels, pxIndex + 3, 255 - transparency * 255)

		pxIndex += 4
		px.color = nil
		px.lightTransparency = nil
		px.transparency = 0
	end
end

local lightingSystem = {}
function lightingSystem.onSetData(data, name, value)
	if name ~= "lights" or not value then
		return value
	end

	for index, light in value do
		local instance = light.Instance
		local range = light.Range * light.Range

		local v2Range = Vector2.new(range, range)
		local absolutePosition = instance.AbsolutePosition
		local absoluteSize = instance.AbsoluteSize

		if IsOutScreen(instance.AbsolutePosition, v2Range * 2) then
			continue
		end

		value[index] = {
			Position = Vector3.new(absolutePosition.X, absolutePosition.Y),
			Size = Vector3.new(absoluteSize.X, absoluteSize.Y),
			Rotation = math.rad(light.Rotation),
			Angle = math.rad(light.Angle),
			Shape = light.Shape:lower(),
			Instance = light.Instance,
			AbsoluteRange = range,
			Range = light.Range,
			Color = light.Color,
			Inverted = light.Inverted,
			Brightness = light.Brightness,
		}
	end

	table.sort(value, sortf)
	return value
end

function lightingSystem.build(data)
	local details = data.details
	local chunk = details.chunk
	local chunkSize = details.chunkSize

	local yFrames = math.round(details.screenSize.Y / chunkSize)
	for y = 0, yFrames do
		local chk = chunk:Clone()
		chk.Position = UDim2.fromOffset(details.x * chunkSize, y * chunkSize)
		chk.Parent = details.screen

		local size = Vector3.new(chk.AbsoluteSize.X, chk.AbsoluteSize.Y)
		local position = Vector3.new(chk.AbsolutePosition.X, chk.AbsolutePosition.Y)
		local pixels = buildCanvas(chunk, position, size)

		table.insert(data.pixels, {
			instance = chk,
			canvas = chk.Canvas,
			position = position,
			size = size,
			content = pixels,
		})
	end
end

function lightingSystem.draw(data)
	local current = clock()
	local lighting = data.lighting

	if current - ms < lighting.updateFrequency then
		return
	end

	local pixels = data.pixels
	ms = current

	local lights = data.lights
	local staticData = {
		ambientTransparency = lighting.ambientTransparency,
	}

	local chunks = {}
	for _, chkData in pixels do
		for _, light in lights do
			if light.Shape == "pointlight" then
				drawPointLight(chkData, light, staticData)
				continue
			end

			drawSpotLight(chkData, light, staticData)
		end

		serializeChunk(chunks, chkData, lighting)
	end

	task.synchronize()
	for _, chkData in pixels do
		local canvas = chkData.canvas :: EditableImage
		canvas:WritePixelsBuffer(Vector2.zero, canvas.Size, chunks[chkData])
	end
end

function lightingSystem.updateScreen(data)
	local lighting = data.lighting
	for _, chkData in data.pixels do
		chkData.instance.ResampleMode = lighting.lightStyle
		chkData.canvas:Resize(lighting.chunkResolution)
		chkData.content = buildCanvas(chkData.instance, chkData.position, chkData.size)
	end
end

return lightingSystem

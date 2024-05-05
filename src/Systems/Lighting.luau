--!native
local getDistance = require(script.Parent.Parent.Private.Util.Math.GetDistance)
local IsOutScreen = require(script.Parent.Parent.Private.Util).IsOutScreen
local normalize = require(script.Parent.Parent.Private.Util).Normalize
local clock = os.clock
local ms = clock()
local axes = {
	Vector3.zero,
	Vector3.new(0, 1),
	Vector3.new(1, 0),
	Vector3.new(1, 1),
}

local function interpolateColor(startColor, endColor, t)
	local str = startColor.R * 255
	local stg = startColor.G * 255
	local stb = startColor.B * 255

	local enr = endColor.R * 255
	local eng = endColor.G * 255
	local enb = endColor.B * 255

	t = (1 - math.cos(t * math.pi)) * 0.5
	return Color3.fromRGB(str * (1 - t) + enr * t, stg * (1 - t) + eng * t, stb * (1 - t) + enb * t)
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

	for _, px in chkData.content do
		local distance = getDistance(px.position, light.Position + light.Size * 0.5)
		local rotatedAngle = getRotatedAngle(light, px.position)

		if distance > absRange or (rotatedAngle <= -angle or rotatedAngle >= angle) then
			continue
		end

		local nDistance = normalize(distance, 0, absRange)
		local transparency = (px.transparency or ambientTransparency) - nDistance + light.Brightness + 1

		local lightTransparency = (light.Transparency + (px.lightTransparency or light.Transparency)) * 0.5
		local color = if px.color then interpolateColor(px.color, light.Color, 1 - nDistance) else light.Color

		px.lightTransparency = lightTransparency
		px.transparency = transparency
		px.color = color
	end
end

local function drawPointLight(chkData, light, staticData)
	local ambientTransparency = staticData.ambientTransparency
	local absRange = light.AbsoluteRange

	if not isBallInsidechunk(chkData, light, light.Range) then
		return
	end

	for _, px in chkData.content do
		local distance = getDistance(px.position, light.Position)
		if distance > absRange then
			continue
		end

		local nDistance = normalize(distance, 0, absRange)
		local transparency = (px.transparency or ambientTransparency) - nDistance + light.Brightness + 1

		local lightTransparency = (light.Transparency + (px.lightTransparency or light.Transparency)) * 0.5
		local color = if px.color then interpolateColor(px.color, light.Color, 1 - nDistance) else light.Color

		px.lightTransparency = lightTransparency
		px.transparency = transparency
		px.color = color
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
	local chkPixels = {}
	chunks[chkData] = chkPixels

	for index, px in chkData.content do
		local isDrawn = px.transparency ~= 0 and px.transparency ~= nil
		local transparency = if isDrawn and px.lightTransparency > lighting.ambientTransparency
			then math.clamp(px.transparency, lighting.ambientTransparency, px.lightTransparency)
			else lighting.ambientTransparency

		local color = if isDrawn
			then interpolateColor(
				px.color,
				lighting.ambientColor,
				math.clamp(lighting.lightIntensity - px.transparency, 0, lighting.lightIntensity)
			)
			else lighting.ambientColor

		local pxIndex = 1 + ((index - 1) * 4)
		chkPixels[pxIndex] = color.R
		chkPixels[pxIndex + 1] = color.G
		chkPixels[pxIndex + 2] = color.B
		chkPixels[pxIndex + 3] = 1 - transparency

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
			Brightness = light.Brightness,
			Transparency = light.Transparency,
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
		local canvas = chkData.canvas
		canvas:WritePixels(Vector2.zero, canvas.Size, chunks[chkData])
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

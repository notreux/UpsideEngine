local getDistance = require(script.Parent.Parent.Private.Util.Math.GetDistance)
local IsOutScreen = require(script.Parent.Parent.Private.Util).IsOutScreen
local normalize = require(script.Parent.Parent.Private.Util).Normalize
local clock = os.clock
local ms = clock()
local axes = {
	Vector2.zero,
	Vector2.new(0, 1),
	Vector2.new(1, 0),
	Vector2.new(1, 1),
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

local function isBallInsideBigPixel(bpx, light, range)
	return bpx.position.X < light.Position.X + range
		and bpx.position.X + bpx.size.X > light.Position.X - range
		and bpx.position.Y < light.Position.Y + range
		and bpx.position.Y + bpx.size.Y > light.Position.Y - range
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

local function isSpotInsideBigPixel(bpx, light, range)
	local lightAngle = light.Angle * 1
	for _, axe in axes do
		local position = bpx.position + bpx.size * axe
		local rotatedAngle = getRotatedAngle(light, position)

		local insideAngle = -lightAngle <= rotatedAngle and rotatedAngle <= lightAngle
		local insideRange = getDistance(position + bpx.size * 0.5, light.Position + light.Size * 0.5)
			< light.AbsoluteRange * 1.6

		if insideAngle and insideRange then
			return true
		end
	end

	return false
end

local function drawSpotLight(bpxData, light, staticData)
	local update = staticData.update
	local ambientTransparency = staticData.ambientTransparency
	local absRange = light.AbsoluteRange
	local angle = light.Angle * 0.5

	if not isSpotInsideBigPixel(bpxData, light, light.Range) then
		return
	elseif not update[bpxData] then
		update[bpxData] = {}
	end

	for _, px in bpxData.childs do
		local distance = getDistance(px.position + px.size * 0.5, light.Position + light.Size * 0.5)
		local rotatedAngle = getRotatedAngle(light, px.position)

		if distance > absRange or (rotatedAngle <= -angle or rotatedAngle >= angle) then
			continue
		end

		local nDistance = normalize(distance, 0, absRange)
		local transparency = (px.transparency or ambientTransparency) - nDistance + light.Brightness + 1

		local lightTransparency = (light.Transparency + (px.lightTransparency or light.Transparency)) * 0.5
		local color = if px.color then interpolateColor(px.color, light.Color, 1 - nDistance) else light.Color

		update[bpxData][px] = true
		px.lightTransparency = lightTransparency
		px.transparency = transparency
		px.color = color
	end
end

local function drawPointLight(bpxData, light, staticData)
	local update = staticData.update
	local ambientTransparency = staticData.ambientTransparency
	local absRange = light.AbsoluteRange

	if not isBallInsideBigPixel(bpxData, light, light.Range) then
		return
	elseif not update[bpxData] then
		update[bpxData] = {}
	end

	for _, px in bpxData.childs do
		local distance = getDistance(px.position, light.Position)
		if distance > absRange then
			continue
		end

		local nDistance = normalize(distance, 0, absRange)
		local transparency = (px.transparency or ambientTransparency) - nDistance + light.Brightness + 1

		local lightTransparency = (light.Transparency + (px.lightTransparency or light.Transparency)) * 0.5
		local color = if px.color then interpolateColor(px.color, light.Color, 1 - nDistance) else light.Color

		update[bpxData][px] = true
		px.lightTransparency = lightTransparency
		px.transparency = transparency
		px.color = color
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

		local absoluteSize = Vector2.new(range, range)
		local absolutePosition = instance.AbsolutePosition

		if IsOutScreen(absolutePosition, absoluteSize * 2) then
			continue
		end

		value[index] = {
			Instance = light.Instance,
			Brightness = light.Brightness,
			Position = absolutePosition,
			Size = light.Instance.AbsoluteSize,
			AbsoluteRange = range,
			Angle = math.rad(light.Angle),
			Rotation = math.rad(light.Rotation),
			Shape = light.Shape:lower(),
			Range = light.Range,
			Color = light.Color,
			Transparency = light.Transparency,
		}
	end

	table.sort(value, sortf)
	return value
end

function lightingSystem.build(data)
	local details = data.details
	local bigPixel = details.bigPixel
	local bigPixelSize = details.bigPixelSize

	for y = 0, details.screenSize.Y / bigPixelSize do
		local px = bigPixel:Clone()
		px.Position = UDim2.fromOffset(details.x * bigPixelSize, y * bigPixelSize)
		px.Parent = details.screen

		local childs = px.Canvas:GetChildren()
		for i = 1, #childs do
			local instance = childs[i]
			childs[i] = {
				instance = instance,
				position = instance.AbsolutePosition,
				size = instance.AbsoluteSize,
			}
		end

		table.insert(data.pixels, {
			instance = px,
			position = px.AbsolutePosition,
			size = px.AbsoluteSize,
			childs = childs,
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
	local update = {}

	local staticData = {
		update = update,
		ambientTransparency = lighting.ambientTransparency,
	}

	for bigPixel, bpxData in pixels do
		for _, light in lights do
			if light.Shape == "pointlight" then
				drawPointLight(bpxData, light, staticData)
				continue
			end

			drawSpotLight(bpxData, light, staticData)
		end
	end

	task.synchronize()
	for bigPixel, drawn in update do
		local bpxInstance = bigPixel.instance
		bpxInstance.BackgroundTransparency = 1
		bpxInstance.Canvas.Visible = true

		for _, px in bigPixel.childs do
			local isDrawn = drawn[px]
			local instance = px.instance

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

			px.color = nil
			px.transparency = nil

			instance.BackgroundTransparency = transparency
			instance.BackgroundColor3 = color
		end
	end

	for _, bigPixel in pixels do
		if update[bigPixel] then
			continue
		end

		local instance = bigPixel.instance
		instance.Canvas.Visible = false
		instance.BackgroundTransparency = lighting.ambientTransparency
		instance.BackgroundColor3 = lighting.ambientColor
	end
end

return lightingSystem

local isOutSceen = require(script.Parent.Parent.Private.Util).IsOutSceen
local normalize = require(script.Parent.Parent.Private.Util).Normalize
local clock = os.clock
local ms = clock()

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

local function getDistance(v1, v2)
	local direction = v1 - v2
	return direction:Dot(direction)
end

local function isInsideBigPixel(bpx, light, range)
	return bpx.position.X < light.Position.X + range
		and bpx.position.X + bpx.size.X > light.Position.X - range
		and bpx.position.Y < light.Position.Y + range
		and bpx.position.Y + bpx.size.Y > light.Position.Y - range
end

local self = {}
function self.onSetData(data, name, value)
	if name ~= "lights" or not value then
		return value
	end

	for index, light in value do
		local instance = light.Instance
		local range = light.Range * light.Range

		local absoluteSize = Vector2.new(range, range)
		local absolutePosition = instance.AbsolutePosition + (absoluteSize / data.resolution)

		if isOutSceen(absolutePosition, absoluteSize * 2) then
			continue
		end

		value[index] = {
			Instance = light.Instance,
			Brightness = light.Brightness,
			Position = absolutePosition,
			AbsoluteRange = range,
			Range = light.Range,
			Color = light.Color,
			Transparency = light.Transparency,
		}
	end

	table.sort(value, sortf)
	return value
end

function self.build(data)
	local details = data.details
	local bigPixel = details.bigPixel
	local bigPixelSize = details.bigPixelSize

	for y = 1, details.screenSize.Y / bigPixelSize do
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

function self.draw(data)
	local current = clock()
	local lighting = data.lighting

	if current - ms < lighting.updateFrequency then
		return
	end

	local pixels = data.pixels
	ms = current

	local lights = data.lights
	local update = {}

	for bigPixel, bpxData in pixels do
		for _, light in lights do
			if not isInsideBigPixel(bpxData, light, light.Range) then
				continue
			elseif not update[bpxData] then
				update[bpxData] = {}
			end

			for _, px in bpxData.childs do
				local distance = getDistance(px.position, light.Position)
				if distance < light.AbsoluteRange then
					local nDistance = normalize(distance, 0, light.AbsoluteRange)
					local transparency = (px.transparency or lighting.ambientTransparency)
						- nDistance
						+ light.Brightness
						+ 1

					local lightTransparency = (light.Transparency + (px.lightTransparency or light.Transparency)) * 0.5
					local color = if px.color
						then interpolateColor(px.color, light.Color, 1 - nDistance)
						else light.Color

					update[bpxData][px] = true
					px.lightTransparency = lightTransparency
					px.transparency = transparency
					px.color = color
				end
			end
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

return self

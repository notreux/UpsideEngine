local isOutSceen = require(script.Parent.Parent.Parent.Private.Util).IsOutSceen
local normalize = require(script.Parent.Parent.Parent.Private.Util).Normalize
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
	return bpx.AbsolutePosition.X < light.absolutePosition.X + range
		and bpx.AbsolutePosition.X + bpx.AbsoluteSize.X > light.absolutePosition.X - range
		and bpx.AbsolutePosition.Y < light.absolutePosition.Y + range
		and bpx.AbsolutePosition.Y + bpx.AbsoluteSize.Y > light.absolutePosition.Y - range
end

return function(scene)
	local current = clock()
	local lighting = scene.LightingEnvironment
	if current - ms < lighting.UpdateFrequency or not lighting.ready then
		return
	end

	local resolution = scene.Instance.GameFrame.AbsoluteSize
	local pixels = lighting.__Pixels

	local lights = {}
	local update = {}
	ms = current

	for _, light in lighting.Content do
		local instance = light.Instance
		local range = light.Range * light.Range

		local absoluteSize = Vector2.new(range, range)
		local absolutePosition = instance.AbsolutePosition + (absoluteSize / resolution)

		if not light.Track or isOutSceen(absolutePosition, absoluteSize * 2) then
			continue
		end

		table.insert(lights, {
			brightness = light.Brightness,
			absolutePosition = absolutePosition,
			absoluteRange = range,
			range = light.Range,
			color = light.Color,
			transparency = light.Transparency,
		})
	end

	table.sort(lights, sortf)
	for bigPixel, childs in pixels do
		for _, light in lights do
			if not isInsideBigPixel(bigPixel, light, light.range) then
				continue
			elseif not update[bigPixel] then
				update[bigPixel] = {}
			end

			for _, px in childs do
				local distance = getDistance(px.position, light.absolutePosition)
				if distance < light.absoluteRange then
					local nDistance = normalize(distance, 0, light.absoluteRange)
					local transparency = (px.transparency or lighting.AmbientTransparency)
						- nDistance
						+ light.brightness
						+ 1

					local lightTransparency = (light.transparency + (px.lightTransparency or light.transparency)) * 0.5
					local color = if px.color
						then interpolateColor(px.color, light.color, 1 - nDistance)
						else light.color

					update[bigPixel][px] = true
					px.lightTransparency = lightTransparency
					px.transparency = transparency
					px.color = color
				end
			end
		end
	end

	for bigPixel, drawn in update do
		local childs = pixels[bigPixel]
		bigPixel.BackgroundTransparency = 1
		bigPixel.Canvas.Visible = true

		for _, px in childs do
			local isDrawn = drawn[px]
			local instance = px.instance

			local transparency = if isDrawn and px.lightTransparency > lighting.AmbientTransparency
				then math.clamp(px.transparency, lighting.AmbientTransparency, px.lightTransparency)
				else lighting.AmbientTransparency

			local color = if isDrawn
				then interpolateColor(
					px.color,
					lighting.AmbientColor,
					math.clamp(lighting.LightIntensity - px.transparency, 0, lighting.LightIntensity)
				)
				else lighting.AmbientColor

			px.color = nil
			px.transparency = nil

			instance.BackgroundTransparency = transparency
			instance.BackgroundColor3 = color
		end
	end

	for bigPixel, childs in lighting.__UpdateMemory do
		if update[bigPixel] then
			continue
		end

		bigPixel.Canvas.Visible = false
		bigPixel.BackgroundTransparency = lighting.AmbientTransparency
		bigPixel.BackgroundColor3 = lighting.AmbientColor
	end

	lighting.__UpdateMemory = update
end

local normalize = require(script.Parent.Parent.Parent.Private.Util).Normalize
local clock = os.clock
local ms = clock()

local function mixChannel(c1, c2, amount)
	c1 = (c1 * 255) * amount
	c2 = (c2 * 255) * (255 - amount)
	
	return c1 + c2
end

local function mixColors(c1, c2, amount)
	return Color3.fromRGB(
		mixChannel(c1.R, c2.R, amount),
		mixChannel(c1.G, c2.G, amount),
		mixChannel(c1.B, c2.B, amount)
	)
end

local function sortf(l1, l2)
	return l1.range > l2.range
end

local function getDistance(v1, v2)
	local direction = v1 - v2
	return direction:Dot(direction)
end

local function isOutScreen(ap, absoluteSize)
	local resolution = workspace.CurrentCamera.ViewportSize
	local fakeRes = resolution + absoluteSize
	return ap.X < -absoluteSize.X or ap.Y < -absoluteSize.Y or ap.X > fakeRes.X or ap.Y > fakeRes.Y
end

local function draw(lighting, largePixel, light)
	for _, pixel in largePixel do
		local distance = getDistance(pixel.absolutePosition, light.absolutePosition)
		if light.range < distance then
			continue
		end
		
		local transparency = (light.range * 1.05 - distance) * (light.brightness * lighting.LightingIntensity)
		pixel.transparency += transparency
		pixel.color = pixel.color and mixColors(pixel.color, light.color, normalize(distance, 0, light.range))
		or light.color
	end
end

return function(scene)
	local current = clock()
	local lighting = scene.LightingEnvironment
	if current - ms < lighting.UpdateFrequency or not lighting.Pixels[1] then
		return
	end

	local resolution = workspace.CurrentCamera.ViewportSize
	local pixels = lighting.Pixels
	local lights = {}
	ms = current
	
	for _, light in pairs(lighting.Content) do
		local instance = light.Instance
		local range = light.Range * resolution.X
		
		local absoluteSize = Vector2.new(range, range)
		local absolutePosition = instance.AbsolutePosition + (absoluteSize / resolution)

		if not light.Track or isOutScreen(absolutePosition, absoluteSize * 2) then
			continue
		end

		table.insert(lights, {
			brightness = light.Brightness,
			absolutePosition = absolutePosition,
			range = range,
			color = light.Color,
		})
	end

	table.sort(lights, sortf)
	for _, largePixel in pixels do
		local pixel = largePixel[lighting.PixelIndex]
		for _, light in lights do
			local distance = getDistance(pixel.absolutePosition, light.absolutePosition)
			distance = distance - lighting.Distance

			if light.range > distance then
				draw(lighting, largePixel, light)
			end
		end
	end

	for _, largePixel in pixels do
		for _, pixel in largePixel do
			local instance = pixel.instance
			instance.BackgroundTransparency = lighting.AmbientTransparency + (pixel.transparency or 0)
			instance.BackgroundColor3 = pixel.color
					and mixColors(pixel.color, lighting.AmbientColor, pixel.transparency * 2.5)
				or lighting.AmbientColor

			pixel.color = nil
			pixel.transparency = lighting.AmbientTransparency
		end
	end
end

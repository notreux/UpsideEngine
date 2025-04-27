local RunService = game:GetService("RunService")
local TextTag = require(script.Parent.Parent.Classes.Public.TextTag)
local frameRate = 60

local function createRandomDecayRenderFunction(defaultIntensity)
	return function(label, i, args)
		local intensity = args.intensity or defaultIntensity
		local duration = args.duration or 1
		local steps = math.max(1, math.floor(duration * frameRate))
		for step = 0, steps do
			local currentIntensity = intensity * (1 - step / steps)
			label.Position = UDim2.new(
				0,
				math.random(-currentIntensity, currentIntensity),
				0,
				math.random(-currentIntensity, currentIntensity)
			)
			task.wait(duration / steps)
		end
		label.Position = UDim2.new(0, 0, 0, 0)
	end
end

local function createWaveRenderFunction(defaultAmplitude)
	return function(label, i, args)
		local amplitude = args.intensity or defaultAmplitude
		local duration = args.duration or 1
		local steps = math.max(1, math.floor(duration * frameRate))
		for step = 0, steps do
			local phase = (2 * math.pi) * (step / steps) + (i or 0)
			local offsetY = amplitude * math.sin(phase)
			label.Position = UDim2.new(0, 0, 0, offsetY)
			task.wait(duration / steps)
		end
		label.Position = UDim2.new(0, 0, 0, 0)
	end
end


local function createGradientRenderFunction(defaultStartColor, defaultEndColor)
	return function(label, index, args)
		local startColor = args.startColor and Color3.fromHex(args.startColor) or defaultStartColor
		local endColor = args.endColor and Color3.fromHex(args.endColor) or defaultEndColor
		local finalTextColor = args.finalTextColor and Color3.fromHex(args.finalTextColor) or Color3.new(1, 1, 1)

		local totalDuration = args.duration or 5
		local cycleDur = args.cycleDuration or 1
		local offsetFactor = args.offsetFactor or 0.1
		local baseOffset = 1 - ((index - 1) * offsetFactor)
		local startTime = os.clock()

		local connection
		connection = RunService.RenderStepped:Connect(function()
			local now = os.clock()
			local elapsed = now - startTime

			if elapsed >= totalDuration then
				connection:Disconnect()
				return
			end

			local cycleT = elapsed % cycleDur
			local shift = 0.4 * math.sin(cycleT * (math.pi * 2))
			local unsat = baseOffset + shift
			local fraction = 1 - math.abs((unsat % 2) - 1)

			local gradientColor = startColor:Lerp(endColor, fraction)
			local blendFactor = (totalDuration - elapsed <= cycleDur) and cycleT or 0
			label.TextColor3 = gradientColor:Lerp(finalTextColor, blendFactor)
		end)
	end
end

local angry = TextTag.new()
angry.TypingSoundId = "rbxassetid://110332722919137"
angry.WordsPerSecond = 2
angry:SetTagName("angry")
angry:SetDisplayMode("word")
angry:SetRenderFunction(createRandomDecayRenderFunction(2))

local shake = TextTag.new()
shake:SetTagName("shake")
shake:SetRenderFunction(createRandomDecayRenderFunction(5))

local wave = TextTag.new()
wave:SetTagName("wave")
wave:SetRenderFunction(createWaveRenderFunction(5))

local gradient = TextTag.new()
gradient:SetTagName("gradient")
gradient:SetRenderFunction(createGradientRenderFunction(Color3.new(1, 1, 1), Color3.new(0, 0, 0)))

return {
	angry = angry,
	shake = shake,
	wave = wave,
	gradient = gradient,
}

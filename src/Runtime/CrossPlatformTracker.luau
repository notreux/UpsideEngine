local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local runService = game:GetService("RunService")
local upsideEngine = script.Parent.Parent

local crossPlatformService = require(upsideEngine.Services).CrossPlatformService
local util = require(upsideEngine.Private.Util)

local configs = crossPlatformService.Configs
local wrap = util.Wrap

local controls = {
	up = false,
	left = false,
	right = false,
	down = false,
	jump = false,
}
local directions = {
	up = Vector2.new(0, 1),
	left = Vector2.new(-1, 0),
	right = Vector2.new(1, 0),
	down = Vector2.new(0, -1),
	jump = Vector2.zero,
	idle = Vector2.zero,
}

local function onUserInput(state, input)
	local character = crossPlatformService.Character
	local activated = crossPlatformService.DefaultControllersEnabled

	local action = input.Action:lower()
	if not activated or not character.Sprites or not directions[action] then
		return
	end

	local begin = state == "Begin"
	local value = directions[action] or Vector2.zero

	local jumping = (action == "jump" or action == "up") and crossPlatformService.SideView
	controls[action] = begin

	if jumping and begin and character.IsGrounded then
		return character:Jump()
	elseif not begin and not jumping then
		value /= character.WalkSpeed * 10
		character.Velocity = value
	elseif begin then
		value *= character.WalkSpeed * 10
		character.Velocity = value
	end

	return
end

local function getStickDirection(position, config)
	local action, smaller = "Idle", 10
	local direction = position.Unit

	for _, keyword in config do
		keyword = keyword:lower()

		local vector = directions[keyword]
		local magnitude = (vector - direction).Magnitude

		if magnitude < smaller then
			smaller = magnitude
			action = keyword
		end
	end

	return action
end

local function inputDetector(input, gpe)
	local inputType = input.UserInputType.Name
	local keyName = input.KeyCode.Name

	local device = inputType:match("Gamepad") and "Gamepad" or inputType:match("InputMethod") and "Mobile" or "Keyboard"
	local config = configs[device][keyName]

	if not config or inputType == "Keyboard" and gpe then
		return
	end

	local sensibility = crossPlatformService.StickSensibility
	local inputState = "Input" .. input.UserInputState.Name

	local position = Vector2.new(input.Position.X, input.Position.Y)
	local action = typeof(config) ~= "table" and config or getStickDirection(position * sensibility, config)

	crossPlatformService:Fire(inputState, {
		Action = action,
		Position = position,
		KeyCode = input.KeyCode,
	})
end

local function inputSetup(obj, func)
	for _, event in ipairs({ "Began", "Changed", "Ended" }) do
		obj["Input" .. event]:Connect(func)
	end
end

local function mobileSetup()
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local touchControlFrame = playerGui:WaitForChild("TouchGui"):WaitForChild("TouchControlFrame")
	local thumbstick = touchControlFrame:WaitForChild("ThumbstickFrame")

	local stick = thumbstick:WaitForChild("StickImage")
	local jumpButton = touchControlFrame:WaitForChild("JumpButton")

	local margin = Vector2.new(30, 30)
	local jumpKeyCode = {
		Name = "JumpButton",
		EnumType = "KeyCode",
		Value = 5,
	}

	local function onInput(keyCode, input)
		local position = util.ToVector2(stick.Position, "Offset") - margin
		position = keyCode == Enum.KeyCode.Up and Vector2.zero or position
		position = Vector2.new(position.X, -position.Y)

		inputDetector({
			Position = position,
			UserInputState = input.UserInputState,
			UserInputType = Enum.UserInputType.InputMethod,
			KeyCode = keyCode,
		})
	end

	inputSetup(stick, wrap(onInput, Enum.KeyCode.Thumbstick1))
	inputSetup(jumpButton, wrap(onInput, jumpKeyCode))

	local changed = false
	runService.Heartbeat:Connect(function()
		local position = stick.Position

		if position.X.Offset == 17 and changed then
			changed = false
			inputDetector({
				Position = Vector2.zero,
				UserInputState = Enum.UserInputState.End,
				UserInputType = Enum.UserInputType.InputMethod,
				KeyCode = Enum.KeyCode.Thumbstick1,
			})
		elseif position.X.Offset ~= 17 or position.Y.Offset ~= 17 then
			changed = true
		end
	end)
end

if uis.TouchEnabled then
	coroutine.wrap(pcall)(mobileSetup)
end

game.StarterPlayer.DevTouchMovementMode = Enum.DevTouchMovementMode.Thumbstick
inputSetup(uis, inputDetector)

crossPlatformService:On("InputBegin", wrap(onUserInput, "Begin"))
crossPlatformService:On("InputChange", wrap(onUserInput, "Begin"))
crossPlatformService:On("InputEnd", wrap(onUserInput, "Ended"))
local last = ""
RunService.Heartbeat:Connect(function()
	local character = crossPlatformService.Character
	local action = "idle"
	
	for control, enabled in controls do
		if not enabled or not character.Sprites[action] then
			continue
		end

		action = control
	end

	if action == "up" and crossPlatformService.SideView then
		action = "jump"
	end

	if action == last then
		return
	end

	last = action
	return character:Play(action)
end)

return {}

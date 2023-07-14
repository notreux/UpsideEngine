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
	up = Vector2.new(0, -1),
	left = Vector2.new(-1, 0),
	right = Vector2.new(1, 0),
	down = Vector2.new(0, 1),
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
	local isLateral = (action == "left" or action == "right")
	value *= character.WalkSpeed * 10

	for _, key in { "X", "Y" } do
		if not begin and character.Velocity[key] == 0 and value[key] ~= 0 then
			controls[action] = false
			return
		end
	end

	if isLateral and begin then
		character.Velocity = Vector2.new(0, character.Velocity.Y)
		controls.left = false
		controls.right = false
	elseif action == "idle" then
		character.Velocity = Vector2.zero
	end
	if jumping and begin and character.IsGrounded then
		return character:Jump()
	elseif not begin and controls[action] and not jumping then
		character.Velocity -= value
	elseif begin and not controls[action] then
		character.Velocity += value
	end

	controls[action] = begin
	return
end

local function getStickDirection(position, config)
	local action, smaller = "idle", 10
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

	local jumpKeyCode = {
		Name = "JumpButton",
		EnumType = "KeyCode",
		Value = 5,
	}

	inputSetup(jumpButton, function()
		inputDetector({
			Position = Vector2.zero,
			UserInputState = Enum.UserInputState.Begin,
			UserInputType = Enum.UserInputType.InputMethod,
			KeyCode = jumpKeyCode,
		})
	end)

	local changed = false
	local base = Vector2.new(17, 17)
	runService.Heartbeat:Connect(function()
		local position = Vector2.new(stick.Position.X.Offset, stick.Position.Y.Offset)
		position = position - base
		position = Vector2.new(position.X, -position.Y)

		if position.X == 0 and changed then
			changed = false
			inputDetector({
				Position = Vector2.zero,
				UserInputState = Enum.UserInputState.End,
				UserInputType = Enum.UserInputType.InputMethod,
				KeyCode = Enum.KeyCode.Thumbstick1,
			})
		elseif position.X ~= 0 then
			changed = true
			inputDetector({
				Position = position,
				UserInputState = Enum.UserInputState.Begin,
				UserInputType = Enum.UserInputType.InputMethod,
				KeyCode = Enum.KeyCode.Thumbstick1,
			})
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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local runService = game:GetService("RunService")
local upsideEngine = script.Parent.Parent

local crossPlatformService = require(upsideEngine.Services).CrossPlatformService
local util = require(upsideEngine.Lib.Util)

local configs = crossPlatformService.Configs
local wrap = util.Wrap

local actions = {
	up = false,
	left = false,
	right = false,
	down = false,
}

local directions = {
	up = Vector2.new(0, -1),
	left = Vector2.new(-1, 0),
	right = Vector2.new(1, 0),
	down = Vector2.new(0, 1),
}

local function onUserInput(state, input)
	local controlsEnabled = crossPlatformService.DefaultControllersEnabled
	local character = crossPlatformService.Character
	local action = input.Action:lower()

	local isValid = not character.Sprites or not directions[action]
	local begin = state == "Begin"

	if not controlsEnabled or isValid then
		return
	end

	actions[action] = begin
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
	for _, event in { "Began", "Changed", "Ended" } do
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

local lastAction = ""
local function animationPlayer(character, sideView)
	local defaultIdle = if sideView then "idle_right" else "idle_down"
	local action = "none"
	local animation = "idle"

	for control, enabled in actions do
		if not enabled then
			continue
		end

		action = control
		animation = control
	end

	if action == lastAction or sideView and character.IsJumping and lastAction == "up" then
		return
	elseif action == "none" and not lastAction:match("idle") then
		animation = ("idle_%s"):format(lastAction)
	end

	lastAction = action
	animation = if animation == "idle" then defaultIdle else animation

	character:Play(animation)
end

local function characterController(character, sideView)
	local velocity = Vector2.zero
	if actions.up and sideView and character.IsGrounded then
		character:Jump()
	end

	for key, direction in directions do
		local active = actions[key]
		if not active or key == "up" and sideView then
			continue
		end

		velocity += direction
	end

	velocity = if velocity ~= Vector2.zero then velocity.Unit else velocity
	velocity = velocity * character.WalkSpeed * 5

	if velocity == Vector2.zero then
		return
	end

	character.Velocity = if not character.IsGrounded and sideView
		then Vector2.new(velocity.X, character.Velocity.Y)
		else velocity
end

RunService.Heartbeat:Connect(function()
	local character = crossPlatformService.Character
	local sideView = crossPlatformService.SideView

	animationPlayer(character, sideView)
	characterController(character, sideView)
end)

return {}

local player = game.Players.LocalPlayer
local chat = game:GetService("Chat")
local lighting = game:GetService("Lighting")

local players = game:GetService("Players")
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")

local replicatedStorage = game:GetService("ReplicatedStorage")
local serverScriptService = game:GetService("ServerScriptService")
local starterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")

local robloxContentSections = {
	StarterPlayerScripts = {
		"BubbleChat",
		"ChatScript",
		"RbxCharacterSounds",
		"PlayerScriptsLoader",
		"PlayerModule",
	},
	PlayerGui = {
		"BubbleChat",
		"Freecam",
		"Chat",
	},
}

robloxContentSections.PlayerScripts = robloxContentSections.StarterPlayerScripts

return function(options)
	players.CharacterAutoLoads = false
	workspace.Gravity = 0

	local timeOut = options.TimeOut or 1
	local instances = {
		replicatedStorage:WaitForChild("DefaultChatSystemChatEvents", timeOut),
		unpack(workspace:GetChildren()),
	}

	for _, robloxInstance in ipairs(instances) do
		pcall(robloxInstance.Destroy, robloxInstance)
	end

	if runService:IsServer() then
		local ChatServiceRunner = serverScriptService:WaitForChild("ChatServiceRunner", timeOut)
		if ChatServiceRunner then
			ChatServiceRunner:Destroy()
		end
	elseif player then
		local sections = {
			PlayerGui = player:WaitForChild("PlayerGui", timeOut),
			PlayerScripts = player:WaitForChild("PlayerScripts", timeOut),
			StarterPlayerScripts = starterPlayerScripts,
		}

		for section, robloxContent in robloxContentSections do
			for _, robloxInstance in ipairs(robloxContent) do
				robloxInstance = sections[section]:WaitForChild(robloxInstance, timeOut)
				if robloxInstance then
					robloxInstance:Destroy()
				end
			end
		end

		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = CFrame.new(0, 0, 0)
		camera.FieldOfView = 1
	end

	lighting:ClearAllChildren()
	if options and options.DeleteChat then
		starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
		chat:ClearAllChildren()
	end
end

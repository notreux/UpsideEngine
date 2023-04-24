local upsideEngine = script.Parent.Parent
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local isClient = runService:IsClient()
local socket = game.ReplicatedStorage:WaitForChild("UpsideEngineSocket")

local request = require(upsideEngine.Classes.Internal.Request)
local networkingService = require(upsideEngine.Services.NetworkingService)

local users = networkingService.Players
local event = isClient and "OnClientEvent" or "OnServerEvent"

local function onEvent(server, client)
	local data = client or server
	if typeof(data) == "table" then
		networkingService:Fire("ReplicationRequest", request:new(data.ClientId, data.Content))
	end
end
local function onPlayerAdded(player)
	users[player.UserId] = {}
	local objects = users[players.LocalPlayer.UserId]

	for _, object in pairs(objects) do
		networkingService:Replicate(object)
	end
end

local function onPlayerLeave(player)
	if not users[player.UserId] or not networkingService.DestroyObjectsOnLeave then
		return
	end

	for _, object in pairs(users[player.UserId]) do
		object:Destroy()
	end

	users[player.UserId] = nil
end

if isClient then
	game.Players.PlayerAdded:Connect(onPlayerAdded)
	game.Players.PlayerRemoving:Connect(onPlayerLeave)
end

for _, player in ipairs(players:GetPlayers()) do
	users[player.UserId] = {}
end

socket[event]:Connect(onEvent)
return {}

local upsideEngine = script.Parent.Parent
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local isClient = runService:IsClient()
local socket = game.ReplicatedStorage:WaitForChild("UpsideEngineSocket")

local request = require(upsideEngine.Classes.Internal.Request)
local networkingService = require(upsideEngine.Services.NetworkingService)

local users = networkingService.Players
local event = isClient and "OnClientEvent" or "OnServerEvent"

local function buildRequests(requests)
	for _, data in requests do
		local pendingRequest = request.new(data.ClientId, data.Content)
		networkingService:Fire("ReplicationRequest", pendingRequest)
	end
end

local function onEvent(client, server)
	local pending = server or client
	if typeof(pending) ~= "table" then
		return
	elseif server then
		buildRequests(pending)
		return
	end

	local userId = tostring(players.LocalPlayer.UserId)
	pending[userId] = nil

	for clientId, requests in pending do
		buildRequests(requests)
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

runService.Heartbeat:Connect(function()
	local pending = networkingService.Pending
	local _, element = next(pending)

	if element == nil then
		return
	elseif isClient then
		socket:FireServer(pending)
		networkingService.Pending = {}

		return
	end

	local clients = {}
	for index, data in pending do
		local clientId = data.ClientId
		local clientData = clients[clientId]

		if not clientData then
			clientData = {}
			clients[clientId] = clientData
		end

		clientData[index] = data
		pending[index] = nil
	end

	socket:FireAllClients(clients)
end)

socket[event]:Connect(onEvent)
return {}

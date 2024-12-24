local upsideEngine = script.Parent.Parent
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local ToVector2 = require(script.Parent.Parent.Private.Util.DataType.ToVector2)
local copyTable = require(script.Parent.Parent.Private.Util.Internal.CopyTable)
local isEqual = require(script.Parent.Parent.Private.Util.Internal.IsEqual)
local getDistance = require(script.Parent.Parent.Private.Util.Math.GetDistance)
local request = require(upsideEngine.Classes.Internal.Request)
local networkingService = require(upsideEngine.Services.NetworkingService)

local socket = game.ReplicatedStorage:WaitForChild("UpsideEngineSocket")
local isServer = runService:IsServer()

local playersData = networkingService.PlayersData
local replicationTarget = networkingService.ReplicationTarget

local replicationTicks = 1 / 10
local replicationTimer = 0

local event = isServer and "OnServerEvent" or "OnClientEvent"
local requestHandler = {}

function requestHandler.replicate(client, pending)
	if typeof(pending) ~= "table" then
		return
	elseif isServer then
		buildRequests(pending)
		return
	end

	for _, requests in pending do
		buildRequests(requests)
	end
end

function buildRequests(requests)
	for _, data in requests do
		local content = data.Content
		local clientId = data.ClientId

		local pendingRequest = request.new(clientId, content)
		networkingService:Fire("ReplicationRequest", pendingRequest)
	end
end

local function onEvent(client, requestType, pending)
	local handle = requestHandler[requestType] :: () -> nil
	handle(client, pending)
end

local function onPlayerAdded(player)
	playersData[player.UserId] = {}
	if not isServer then
		return
	end

	for retries = 1, 10 do
		local data = table.clone(playersData)
		data[player.UserId] = nil

		socket:FireClient(player, "replicate", data)
		task.wait(1)
	end
end

local function onPlayerLeave(player)
	local skip = not networkingService.DestroyObjectsOnLeave
	local data = playersData[player.UserId]
	playersData[player.UserId] = nil

	if skip or isServer then
		return
	end

	for _, object in data do
		replicationTarget[object] = nil
		object:Destroy()
	end
end

local function sendClientRequests(pending)
	socket:FireServer("replicate", pending)
end

local function getTableSafe(object, key)
	if not object[key] then
		object[key] = {}
	end

	return object[key]
end

local function removeCachedProperties(data, cached)
	for key, value in data do
		if not isEqual(value, cached[key]) then
			continue
		end

		data[key] = nil
	end
end

local function sendServerRequests(pending)
	local clients = {}
	for index, data in pending do
		local content = data.Content
		local id = content.ObjectId

		local clientId = data.ClientId
		local toCache = copyTable(data)

		local clientData = getTableSafe(clients, clientId)
		local cachedRequest = getTableSafe(playersData[clientId], id)

		local cachedContent = cachedRequest.Content or {}
		local cachedInstance = cachedContent.Instance or {}
		local cachedOP = cachedContent.ObjectProperties or {}

		removeCachedProperties(content.Instance, cachedInstance)
		removeCachedProperties(content.ObjectProperties, cachedOP)

		playersData[clientId][id] = toCache
		clientData[id] = data
		pending[index] = nil
	end

	for _, player in players:GetPlayers() do
		local data = table.clone(clients)
		data[player.UserId] = nil

		socket:FireClient(player, "replicate", data)
	end
end

local function requestManager(deltaTime)
	local pending = networkingService.Pending
	local sendRequests = if isServer then sendServerRequests else sendClientRequests

	local _, element = next(pending)
	replicationTimer += deltaTime

	if not element then
		return
	end

	while replicationTimer > replicationTicks do
		replicationTimer -= replicationTicks
		sendRequests(pending)
	end
end

local function clientInterpolator(deltaTime)
	for object, goals in replicationTarget do
		local instance = object.Instance
		for property, value in goals do
			local iValue = instance[property]:Lerp(value, 0.33)
			local distance = getDistance(ToVector2(iValue, "Offset"), ToVector2(instance[property], "Offset"))

			if distance < 10 then
				continue
			end

			instance[property] = iValue
		end
	end
end

for _, player in players:GetPlayers() do
	playersData[player.UserId] = {}
end

if isServer then
	socket[event]:Connect(onEvent)
else
	socket[event]:Connect(function(...)
		onEvent(players.LocalPlayer, ...)
	end)
end

players.PlayerAdded:Connect(onPlayerAdded)
players.PlayerRemoving:Connect(onPlayerLeave)
runService.Heartbeat:Connect(requestManager)

if not isServer then
	runService.Heartbeat:Connect(clientInterpolator)
end

return {
	PlayersData = playersData,
}

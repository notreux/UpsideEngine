local upsideEngine = script.Parent.Parent
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local request = require(script.Parent.Parent.Classes.Internal.Request)
local ToVector2 = require(script.Parent.Parent.Lib.Util.DataType.ToVector2)
local merge = require(script.Parent.Parent.Lib.Util.Generic.Merge)
local diff = require(script.Parent.Parent.Lib.Util.Internal.Diff)
local getDistance = require(script.Parent.Parent.Lib.Util.Math.GetDistance)
local networkingService = require(upsideEngine.Services.NetworkingService)

local socket = game.ReplicatedStorage:WaitForChild("UpsideEngineSocket")
local isServer = runService:IsServer()

local playersData = networkingService.PlayersData
local replicationTarget = networkingService.ReplicationTarget
local replicationTimer = 0

local event = isServer and "OnServerEvent" or "OnClientEvent"
local endpoints = {}

function endpoints.sync(client, pending)
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
	local handle = endpoints[requestType] :: () -> nil
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

		socket:FireClient(player, "sync", data)
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
	networkingService.Pending = {}
	socket:FireServer("sync", pending)
end

local function sendServerRequests(requests)
	local toSend = {}
	for index, data in requests do
		local content = data.Content
		local objectId = content.ObjectId
		local clientId = data.ClientId

		local cachedRequest = playersData[clientId][objectId] or { Content = {} }
		local cachedContent = cachedRequest.Content

		if toSend[clientId] == nil then
			toSend[clientId] = {}
		end

		requests[index] = nil
		playersData[clientId][objectId] = data
		toSend[clientId][objectId] = {
			ClientId = clientId,
			Content = merge(data.Content, {
				Instance = diff(content.Instance, cachedContent.Instance or {}),
				ObjectProperties = diff(content.ObjectProperties, cachedContent.ObjectProperties or {}),
			}),
		}
	end

	for _, player in players:GetPlayers() do
		local data = table.clone(toSend)
		data[player.UserId] = nil

		socket:FireClient(player, "sync", data)
	end
end

local function requestManager(deltaTime)
	local pending = networkingService.Pending
	local sendRequests = if isServer then sendServerRequests else sendClientRequests

	local replicationTicks = 1 / networkingService.ReplicationPerSecond
	replicationTimer += deltaTime

	while replicationTimer > replicationTicks do
		replicationTimer -= replicationTicks
		if next(pending) then
			sendRequests(pending)
		end
	end
end

local function clientInterpolator(deltaTime)
	for object, goals in replicationTarget do
		local instance = object.Instance
		for property, value in goals do
			local iValue = instance[property]:Lerp(value, 0.33)
			local distance = getDistance(ToVector2(iValue, "Offset"), ToVector2(instance[property], "Offset"))

			if distance < 5 then
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

return {}

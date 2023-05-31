local upsideEngine = script.Parent.Parent.Parent

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)
local restricted = require(upsideEngine.AppData.Data).restricted
local networking

local constructor = {}
local methods = {}

local isServer = runService:IsServer()
local socket

if isServer then
	socket = replicatedStorage:FindFirstChild("UpsideEngineSocket") or Instance.new("RemoteEvent")
	socket.Name = "UpsideEngineSocket"
	socket.Parent = replicatedStorage
else
	socket = replicatedStorage:WaitForChild("UpsideEngineSocket")
end

--[[={
	@link Request.md
}=]]

function constructor:Request(clientId: number, content: Dictionary<string, any>)
	self.ClientId = clientId or players.LocalPlayer.UserId
	self.Content = table.freeze(content or {})
end

local function setProperty(object, property, value)
	object[property] = value
end

--[[={
	@desc Sends the request to the server
	@link void.link
}=]]

function methods:Send(content: Dictionary<string, any>)
	local args = {
		ClientId = self.ClientId,
		Content = content,
	}

	if isServer then
		socket:FireClient(self:GetClient(), args)
	else
		socket:FireServer(args)
	end
end

--[[={
	@desc The request is approved and its replicated to the specified clients, if none is specified it will be replicated to all the clients except to the client who sent the request
	@link void.link
}=]]

function methods:Approve(clients: table)
	if not isServer then
		return
	end

	local args = {
		ClientId = self.ClientId,
		Content = self.Content,
	}

	for _, player in (clients or players:GetPlayers()) do
		if player.UserId ~= self.ClientId then
			socket:FireClient(player, args)
		end
	end
end

--[[={
	@desc Accepts the request and builds the object to be replicated
	@link BaseObject.md
}=]]

function methods:Accept(...): BaseObject
	local content = self.Content
	local class = restricted[upsideEngine.Id].private
	class = class.Classes[content.className]

	local replicated = networking.Players[self.ClientId] or {}
	local isFirstRequest = not replicated[content.id]

	assert(class ~= nil, "Invalid class!")
	local clon = replicated[content.id] or class:new(...)

	if isFirstRequest then
		networking.Players[self.ClientId][content.id] = clon

		clon:SetName(content.name)
		networking:Fire("Build", clon)
	end

	for index, value in pairs(content.properties.object) do
		pcall(setProperty, clon, index, value)
	end

	for index, value in pairs(content.properties.instance) do
		pcall(setProperty, clon.Instance, index, value)
	end

	return clon
end

--[[={
	@desc Returns the player which sent the request
	@link player.link
}=]]

function methods:GetClient(): Player
	return players:GetPlayerByUserId(self.ClientId)
end

task.defer(function()
	upsideEngine = require(upsideEngine.UpsideEngine)
	networking = upsideEngine:GetService("NetworkingService")
end)

--[[={
	@desc This class is used for the client replication
	@about
		@Content The content of the request
		@ClientId The UserId of the client which sent the request if exists 
	@events
		@Build Params -> [BaseObject](BaseObject.md)
		Fired when a request is accepted and the object to be replicated is being built
}=]]

return eventEmitter:Extend(script.Name, {
	constructor = constructor,
	methods = methods,
	readonly = {
		Content = {},
		ClientId = 0,
	},
})

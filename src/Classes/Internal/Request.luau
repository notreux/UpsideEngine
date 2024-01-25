local upsideEngine = script.Parent.Parent.Parent

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)
local classes = {}
local networking

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

local request = {}
request.__index = request

function request.new(clientId: number?, content: RequestContent?): Request
	local data = if content then table.freeze(content) else {}
	local playerId = if clientId ~= nil
		then clientId
		elseif players.LocalPlayer ~= nil then players.LocalPlayer.UserId
		else 0

	local self = eventEmitter.new()
	self:SetClassName(script.Name)

	self.Content = data
	self.ClientId = playerId

	return setmetatable(self, request)
end

local function setProperty(object, property, value)
	object[property] = value
end

--[[={
	@desc Sends the request to the server
	@link void.link
}=]]

function request:Send(content: Dictionary<string, any>)
	local id = (content :: any).Id or tostring(content)
	networking.Pending[id] = {
		ClientId = self.ClientId,
		Content = content,
	}
end

--[[={
	@desc The request is approved and its replicated all the clients
	@link void.link
}=]]

function request:Approve()
	if not isServer then
		return
	end

	self:Send(self.Content)
end

--[[={
	@desc Accepts the request and builds the object to be replicated
	@link BaseObject.md
}=]]

function request:Accept(): BaseObject
	local content = self.Content
	local class = classes[content.ClassName]

	local replicated = networking.Players[self.ClientId] or {}
	local isFirstRequest = not replicated[content.Id]

	assert(class ~= nil, "Invalid class!")
	local clon = replicated[content.Id] or class.new()
	if isFirstRequest then
		networking.Players[self.ClientId][content.Id] = clon

		clon:SetName(content.Name)
		networking:Fire("Build", clon)
	end

	for index, value in pairs(content.Properties.Object) do
		pcall(setProperty, clon, index, value)
	end

	for index, value in pairs(content.Properties.Instance) do
		pcall(setProperty, clon.Instance, index, value)
	end

	return clon
end

--[[={
	@desc Returns the player which sent the request
	@link player.link
}=]]

function request:GetClient(): Player
	return players:GetPlayerByUserId(self.ClientId)
end

task.defer(function()
	for _, module in upsideEngine.Classes.Public:GetChildren() do
		if module.Name:match(".src") then
			continue
		end

		classes[module.Name] = require(module)
	end

	upsideEngine = require(upsideEngine.UpsideEngine)
	networking = upsideEngine.GetService("NetworkingService")
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

return setmetatable(request, eventEmitter)

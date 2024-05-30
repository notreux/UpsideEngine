local upsideEngine = script.Parent.Parent
local players = game:GetService("Players")

local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)
local request = require(upsideEngine.Classes.Internal.Request)
local instanceProperties = require(upsideEngine.AppData.InstanceProperties)

local toSkip = { "ImageRectOffset" }
local networkingService = {}
networkingService.__index = networkingService

function networkingService.new()
	local self = eventEmitter.new()
	self:SetClassName("NetworkingService")
	self.DestroyObjectsOnLeave = true
	self.ReplicationTarget = {}
	self.PlayersData = {}
	self.Pending = {}

	return setmetatable(self, networkingService)
end

local function read(object, index)
	return object[index]
end

local function getInstanceData(object)
	local instance = object.Instance
	local data = {}

	for _, index in instanceProperties do
		local sucess, value = pcall(read, instance, index)
		if not sucess or table.find(toSkip, index) then
			continue
		end

		data[index] = value
	end

	return data
end

local function replicate(self, object, instance)
	local clientId = players.LocalPlayer.UserId
	local playerData = self.PlayersData[clientId]

	local req = request.new()
	local objectProperties = {
		Sprites = object.Sprites,
		IsPlaying = object.IsPlaying,
		Shader = object.Shader,
		Active = {
			Name = object.Active.Name,
			SecondsPerFrame = object.Active.SecondsPerFrame,
		},
	}

	playerData[object.Id] = object
	req:Send({
		ClassName = object.ClassName,
		Id = object.Id,
		Name = object.Name,
		Instance = instance,
		ObjectProperties = objectProperties,
	})

	req:Destroy()
end

--[[={
	@desc Replicates an object to other clients
}=]]

function networkingService:Replicate(object: BaseObject)
	local instance = getInstanceData(object)
	replicate(self, object, instance)
end

--[[={
	@desc Replicates an object and each change on it, and returns the connections that detect each change of the object
	@link Connection.md
	@tsreturns LuaTuple<[Connection, Connection]>
}=]]

function networkingService:ReplicateOnChange(object: BaseObject): RBXScriptConnection
	local function wrapper(property)
		if table.find(toSkip, property) then
			return
		end

		self:Replicate(object)
	end

	wrapper("none")
	return object.Instance.Changed:Connect(wrapper)
end

--[[={
	@desc This class is used to replicate objects to other clients, for example the player character
	@about
		@Players A dictionary with the replicated objects by the clients
		@DestroyObjectsOnLeave Defines if the replicated objects by other clients should be destroyed when they leaves
	@events
		@ReplicationRequest Params -> [Request](Request.md) 
		Fired when a request is received by the client
}=]]

return setmetatable(networkingService, eventEmitter).new()

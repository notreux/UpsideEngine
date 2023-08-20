local upsideEngine = script.Parent.Parent
local players = game:GetService("Players")

local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)
local request = require(upsideEngine.Classes.Internal.Request)
local properties = require(upsideEngine.AppData.EssentialProperties)

local networkingService = {}
networkingService.__index = networkingService

function networkingService.new()
	local self = eventEmitter.new()
	self:SetClassName("NetworkingService")
	self.Players = {}
	self.DestroyObjectsOnLeave = true

	return setmetatable(self, networkingService)
end

local function read(object, index)
	return object[index]
end

local function getData(object)
	local data = { object = {}, instance = {} }
	for _, index in ipairs(properties.object) do
		data.object[index] = object[index]
	end

	for _, index in ipairs(properties.instance) do
		local sucess, value = pcall(read, object.Instance, index)
		if sucess then
			data.instance[index] = value
		end
	end

	return data
end

--[[={
	@desc Replicates an object to other clients
}=]]

function networkingService:Replicate(object: BaseObject)
	local properties = getData(object)
	self.Players[players.LocalPlayer.UserId][object.Id] = object

	local req = request.new()
	req:Send({
		className = object.ClassName,
		id = object.Id,
		name = object.Name,
		properties = properties,
	})

	req:Destroy()
end

--[[={
	@desc Replicates an object and each change on it, and returns the connections that detect each change of the object
	@link Connection.md
	@tsreturns LuaTuple<[Connection, Connection]>
}=]]

function networkingService:ReplicateOnChange(object: BaseObject): RBXScriptConnection
	local function wrapper()
		self:Replicate(object)
	end

	wrapper()
	return object.Instance.Changed:Connect(wrapper)
end

--[[={
	@desc This class is to replicate objects to other clients, for example the player character
	@about
		@Players A dictionary with the replicated objects by the clients
		@DestroyObjectsOnLeave Defines if the replicated objects by other clients should be destroyed when they leaves
	@events
		@ReplicationRequest Params -> [Request](Request.md) 
		Fired when a request is received by the client
}=]]

return setmetatable(networkingService, eventEmitter).new()

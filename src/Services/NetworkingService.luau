local upsideEngine = script.Parent.Parent
local diff = require(script.Parent.Parent.Private.Util.Internal.Diff)
local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)
local request = require(upsideEngine.Classes.Internal.Request)
local eProperties = require(upsideEngine.AppData.EssentialProperties)

local toSkip = { "ImageRectOffset", "none" }
local networkingService = {}
networkingService.__index = networkingService

function networkingService.new()
	local self = eventEmitter.new()
	self:SetClassName("NetworkingService")
	self.ReplicationPerSecond = 15
	self.DestroyObjectsOnLeave = true
	self.ReplicationTarget = {}
	self.PlayersData = {}
	self.Pending = {}
	self.Cache = {}

	return setmetatable(self, networkingService)
end

local function read(object, index)
	return object[index]
end

local function getInstanceData(object)
	local instance = object.Instance
	local data = {}

	for _, index in eProperties.Instance do
		local sucess, value = pcall(read, instance, index)
		if not sucess or table.find(toSkip, index) then
			continue
		elseif index == "Image" and value.Uri == nil then
			value = instance:GetAttribute("url")
		end

		data[index] = value
	end

	return data
end

local function replicate(self, object: Sprite, instance)
	local req = request.new()
	local props = {
		Active = {
			Name = object.Active.Name,
			SecondsPerFrame = object.Active.SecondsPerFrame,
		},
	}

	for className, classProps in eProperties do
		if not object:IsA(className) or className == "PhysicalObject" then
			continue
		end

		for _, baseProp in classProps do
			if baseProp == "Active" then
				continue
			end

			props[baseProp] = object[baseProp]
		end
	end

	if object:IsA("PhysicalObject") and not (object.Anchored and object.TrackCollisions) then
		for _, physicalProp in eProperties.PhysicalObject do
			props[physicalProp] = object[physicalProp]
		end
	end

	local cached = self.Cache[object.Id] or {}
	local instanceData = diff(instance, cached.Instance or {})
	local objPropsData = diff(props, cached.ObjectProperties or {})

	if not (next(instanceData) or next(objPropsData)) then
		return
	end

	local content = {
		ClassName = object.ClassName,
		ObjectId = object.Id,
		Name = object.Name,
		Instance = instance,
		ObjectProperties = props,
	}

	self.Cache[object.Id] = content
	req:Send(content)
	req:Destroy()
end

--[[={
	@desc Replicates an object to other clients
}=]]

function networkingService:Replicate(object: BaseObject)
	local instance = getInstanceData(object)
	replicate(self, object :: Sprite, instance)
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
		@PlayersData Dictionary containing the replicated objects for each client (keyed by UserId)
		@DestroyObjectsOnLeave If true, destroys replicated objects from other clients when they leave
		@ReplicationPerSecond Specifies the number of replication requests per second to send when using ReplicateOnChange
		@ReplicationTarget Table of objects from other clients currently targeted for replication
		@Pending Table of pending replication requests
	@events
		@ReplicationRequest Params -> [Request](Request.md) 
		Fired when a request is received by the client
}=]]

return setmetatable(networkingService, eventEmitter).new()

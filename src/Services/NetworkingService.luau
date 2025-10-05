local upsideEngine = script.Parent.Parent
local copyTable = require(script.Parent.Parent.Lib.Util.Internal.CopyTable)
local diff = require(script.Parent.Parent.Lib.Util.Internal.Diff)
local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)
local request = require(upsideEngine.Classes.Internal.Request)
local properties = require(upsideEngine.AppData.Properties)

local networkingService = {}
networkingService.__index = networkingService

function networkingService.new()
	local self = eventEmitter.new()
	self:SetClassName(script.Name)
	self.ReplicationPerSecond = 15
	self.DestroyObjectsOnLeave = true
	self.ServerReplication = true
	self.ReplicationTarget = {}
	self.RequestsCache = { [0] = {} }
	self.PlayersData = { [0] = {} }
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

	for _, index in properties.Instance do
		local sucess, value = pcall(read, instance, index)
		local isSpritePlaying = index == "ImageRectOffset" and object:IsA("Sprite") and object.IsPlaying

		if not sucess or index == "none" or isSpritePlaying then
			continue
		elseif index == "Image" and instance.ImageContent.Object ~= nil then
			value = instance:GetAttribute("url")
		end

		data[index] = value
	end

	return data
end

local function replicate(self, object)
	local instance = getInstanceData(object)
	local req = request.new()
	local props = {}

	if object:IsA("Sprite") then
		props.Active = {
			Name = object.Active.Name,
			SecondsPerFrame = object.Active.SecondsPerFrame,
		}
	end

	for key, value in object do
		if table.find(properties.NonReplicable, key) or typeof(value) == "Instance" then
			continue
		end

		props[key] = if typeof(value) == "table" --
			then copyTable(value)
			else value
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

	self.PlayersData[0][object.Id] = object
	self.Cache[object.Id] = content
	req:Send(content)
	req:Destroy()
end

--[[={
	@desc Replicates an object to other clients
}=]]

function networkingService:Replicate(object: BaseObject)
	replicate(self, object :: Sprite)
end

--[[={
	@desc Replicates an object and each change on it, and returns the connections that detect each change of the object
	@link Connection.md
	@tsreturns LuaTuple<[Connection, Connection]>
}=]]

function networkingService:ReplicateOnChange(object: BaseObject): RBXScriptConnection
	local function wrapper(property)
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
		@ServerReplication Boolean that determines if server-side replication is enabled, true by default
		@RequestsCache Cache storing replication requests indexed by client (UserId)
		@Cache Dictionary storing cached object data to optimize replication by detecting changes
	@events
		@ReplicationRequest Params -> [Request](Request.md) 
		Fired when a request is received by the client
}=]]

return setmetatable(networkingService, eventEmitter).new()

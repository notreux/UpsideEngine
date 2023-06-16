local ue = script.Parent.Parent
local classes = ue.Classes

local restricted = require(ue.AppData.Data).restricted
local essentialProperties = require(ue.AppData.EssentialProperties)
local eventEmitter = require(classes.Internal.EventEmitter)

local encoder = require(ue.Private.Util).Encoder
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local isStudio = runService:IsStudio()
local isClient = runService:IsClient()

local sceneManager = require(ue.Services.SceneManager)
local methods = {}

function getData(data)
	local result = {}

	for index, value in data do
		local valueType = typeof(value)

		if valueType ~= "table" and valueType ~= "Instance" then
			result[index] = value
			continue
		elseif valueType == "Instance" then
			local instance = value
			value = {}

			for _, property in ipairs(essentialProperties.instance) do
				local sucess, val = pcall(read, instance, property)
				if sucess then
					value[property] = val
				end
			end
		end

		result[index] = getData(value)
	end

	if data.Id then
		result.Id = data.Id
	end

	return result
end

local function setRestricted(object, id, name)
	if object.ClassName == "Scene" then
		sceneManager.Scenes[object.Id] = nil
		sceneManager.ActiveScenes[object.Id] = nil

		sceneManager.Scenes[id] = object
		sceneManager.ActiveScenes[id] = object
	end

	restricted[id] = restricted[object.Id]
	restricted[id].masterAccess.Id = id
	restricted[object.Id] = nil

	object.Id = id
	object:SetName(name)
end

local function rebuild(parent, index, value)
	local object = parent[index]

	if not object or object.ClassName ~= value.ClassName then
		local sucess, class = pcall(require, classes.Public[value.ClassName])
		if not sucess then
			return
		end

		object = class:new(parent)
	end

	if value.Id then
		setRestricted(object, value.Id, value.Name)
	end

	for i, v in value do
		pcall(set, object, i, v)
	end

	return object
end

function set(object, index, value)
	object[index] = typeof(value) ~= "table" and value or rebuild(object, index, value)
end

function read(object, index)
	return object[index]
end

--[[={
	@desc Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	@link void.link
}=]]

function methods:LoadPluginContent()
	local db = encoder.Decode(game.ReplicatedStorage:GetAttribute("UpsideEngineDB") or "{}")
	for _, sceneData in pairs(db) do
		local scene = rebuild({}, 0, sceneData)
		restricted[scene.Camera.Id].readonly.Scene = scene.Id
	end

	for _, scene in pairs(sceneManager.Scenes) do
		for _, object in pairs(scene.Objects) do
			object.Instance.Parent = scene.Instance
			scene:AddObject(object)
		end
	end

	if isClient then
		game.ReplicatedStorage:SetAttribute("UpsideEngineDB", "{}")
	end
end

--[[={
	@desc Saves the engine data in replicated storage as attribute with the name "UpsideEngineDB" can be useful to create plugins
	@link void.link
}=]]

function methods:SavePluginContent(content: {})
	if isStudio then
		local json = encoder.Encode(getData(content or {}))
		replicatedStorage:SetAttribute("UpsideEngineDB", json)
	end
end

--[[={
	@desc This class save and build the engine data
}=]]

return eventEmitter:Extend(script.Name, {
	methods = methods,
	readonly = {},
})

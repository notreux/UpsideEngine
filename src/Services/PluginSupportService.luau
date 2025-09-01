local ue = script.Parent.Parent
local classes = ue.Classes

local objects = require(ue.AppData.Data).objects
local eProperties = require(ue.AppData.EssentialProperties)
local eventEmitter = require(classes.Internal.EventEmitter)

local encoder = require(ue.Lib.Util).Encoder
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local isStudio = runService:IsStudio()
local isClient = runService:IsClient()

local sceneManager = require(ue.Services.SceneManager)
local pluginSupportService = {}
pluginSupportService.__index = pluginSupportService

local classFixes = {
	Environment = function(scene, env)
		env:Run("SetScene", scene)
	end,
	Shader = function(scene, shader)
		for _, object in scene.Objects do
			if not object:IsA("StaticObject") then
				continue
			elseif object.Shader.Id ~= shader.Id then
				continue
			end

			object:SetShader(shader)
		end
	end,
}

function pluginSupportService.new()
	local self = eventEmitter.new()
	return setmetatable(self, pluginSupportService)
end

function getData(data)
	local result = {}

	for index, value in pairs(data) do
		local valueType = typeof(value)
		local isSimple = valueType ~= "table" and valueType ~= "Instance"

		if isSimple then
			result[index] = value
			continue
		elseif valueType == "Instance" then
			local instance = value
			value = {}

			for _, property in eProperties.Instance do
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

local function setObjectIds(object, id, name)
	if object.ClassName == "Scene" then
		sceneManager.Scenes[object.Id] = nil
		sceneManager.ActiveScenes[object.Id] = nil

		sceneManager.Scenes[id] = object
		sceneManager.ActiveScenes[id] = object
	end

	objects[id] = objects[object.Id]
	objects[object.Id] = nil

	object.Id = id
	if object.Instance and object.Instance.Parent and object.Instance.Parent.ClassName ~= "Folder" then
		object:SetName(name)
	end
end

local function rebuild(parent, index, value)
	local object = parent[index]
	if index == "Hitbox" and typeof(value[1]) == "Vector2" then
		for i, v in value do
			value[i] = Vector3.new(v.X, v.Y)
		end
	end

	if value.ClassName and (not object or object.ClassName ~= value.ClassName) then
		local sucess, class = pcall(require, classes.Public[value.ClassName])
		if not sucess then
			return
		end

		object = class.new()
		parent[index] = object

		pcall(function()
			object:SetScene(parent)
		end)
	elseif not object then
		object = {}
	end

	if value.Id then
		setObjectIds(object, value.Id, value.Name)
	end

	for i, v in value do
		pcall(set, object, i, v)
	end

	return object
end

function set(object, index, value)
	object[index] = if typeof(value) ~= "table" then value else rebuild(object, index, value)
end

function read(object, index)
	return object[index]
end

--[[={
	@desc Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	@link void.link
}=]]

function pluginSupportService:LoadPluginContent()
	local db = encoder.Decode(game.ReplicatedStorage:GetAttribute("UpsideEngineDB") or "{}")
	for _, sceneData in pairs(db) do
		if not sceneData.Objects.Content then
			sceneData.Objects = {
				Content = sceneData.Objects,
			}
		end

		local scene = rebuild({}, 0, sceneData)
		scene.Camera.Scene = scene.Id
	end

	for _, scene in pairs(sceneManager.Scenes) do
		for _, object in scene.Objects do
			if not object.SetScene then
				continue
			end

			object.Instance.Parent = scene.Instance.GameFrame
			object:SetScene(scene)

			local fix = classFixes[object.ClassName]
			if not fix then
				continue
			end

			fix(scene, object)
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

function pluginSupportService:SavePluginContent(content: {})
	if isStudio then
		local json = encoder.Encode(getData(content or {}))
		replicatedStorage:SetAttribute("UpsideEngineDB", json)
	end
end

--[[={
	@desc This class save and build the engine data
}=]]

return setmetatable(pluginSupportService, eventEmitter).new()

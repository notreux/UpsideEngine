local data = require(script.Parent.Parent.Parent.Parent.AppData.Data)
local SceneManager = require(script.Parent.Parent.Parent.Parent.Services.SceneManager)
local handlers = {}

local function getObjectScene(object)
	local sceneId = object and object.Scene or ""
	return SceneManager:Get(sceneId)
end

local function subjectObject(object)
	local subject = object.Subject
	local scene = getObjectScene(subject)

	local targetSubject = scene and scene.Objects[subject.Id]
	if not targetSubject then
		return
	end

	object:SetSubject(targetSubject)
end

function handlers.Scene(scene)
	local scenes = SceneManager.Scenes
	local isInScenes = scenes[scene.Id]

	if isInScenes then
		return
	end

	for index, sceneObj in scenes do
		if scene == sceneObj then
			data.objects[index] = nil
			scenes[index] = nil
		end
	end

	data.objects[scene.Id] = scene
	scenes[scene.Id] = scene
end

function handlers.BaseObject(object)
	local scene = getObjectScene(object)
	local skipObject = if scene then scene.Objects:HasOne(object.Id) else true

	if object:IsA("Scene") or skipObject then
		return
	end

	object:SetScene(scene)
end

function handlers.StaticObject(object)
	local shader = object.Shader
	local scene = getObjectScene(object)
	local shaderEnv = if scene --
		then scene.ShaderEnvironment
		else nil

	local isInShaderEnv = if shaderEnv --
		then shaderEnv:HasOne(object.Id)
		else false

	if shader.Path ~= "" and shader.Enabled and not isInShaderEnv then
		object:SetShader(object.Shader)
	elseif not shader.Enabled and isInShaderEnv then
		object:SetShader()
	end
end

handlers.Sound = subjectObject
handlers.Particle = subjectObject

return handlers

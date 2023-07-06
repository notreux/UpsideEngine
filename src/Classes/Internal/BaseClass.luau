local upsideEngine = script.Parent.Parent.Parent
local private = upsideEngine.Private
local appData = upsideEngine.AppData
local baseClass = {}

local data = require(appData.Data)
local essentialProperties = require(appData.EssentialProperties)

local util = require(private.Util)
local class = require(private.Class)

local classEnvironments = {
	Sound = "SoundEnvironment",
	Light = "LightingEnvironment",
	Particle = "ParticleEnvironment",
}

local directories = {
	"constructor",
	"readonly",
	"rules",
	"private",
}

local function addReadonly(id, providedReadonly)
	local readonly = data.restricted[id].readonly

	for index, value in providedReadonly do
		assert(readonly[index] == nil, "This property already exist!")
		readonly[index] = value
	end
end

local function set(self, clon, index)
	clon[index] = self[index]
end

function baseClass:new(args, ...)
	local this = self:Extend(self.ClassName, {})
	local restricted = data.restricted[this.Id]

	local constructors = restricted.constructor
	data.workSpace[this.Name] = this

	for _, constructor in ipairs(constructors) do
		local masterAccess = restricted.masterAccess
		local env = getfenv(constructor)
		env.addReadonly = util.Wrap(addReadonly, this.Id)

		setfenv(constructor, env)
		constructor(masterAccess, args or {})
	end

	return this
end

function baseClass:Clone(...)
	local clon = self:new(...)
	for _, index in ipairs(essentialProperties.instance) do
		pcall(set, self.Instance, clon.Instance, index)
	end

	return clon
end

function baseClass:Extend(className: string, classStructure: any)
	assert(typeof(self.Id) == "string", "You must create an object first!")
	assert(typeof(className) == "string", "You must provide a valid class name!")
	assert(
		typeof(classStructure) == "table",
		("invalid value (%s expected, got %s)"):format("table", typeof(classStructure))
	)

	local this = class.new(className, {})
	local id = this.Id
	local restricted = data.restricted[id]

	local constructors = restricted.constructor
	local readonly = restricted.readonly
	local methods = util.Fuse(data.restricted[self.Id].methods, classStructure.methods)

	for _, dir in directories do
		util.CopyTable(data.restricted[self.Id][dir], restricted[dir])
		util.CopyTable(classStructure[dir] or {}, restricted[dir])
	end

	readonly.ClassName = className
	readonly.Name = ("unnamed-%s"):format(id)

	for name, method in methods do
		if tostring(method) ~= "UpsideFunction" then
			method = util.CreateUpsideFunction(method)
		end

		restricted.methods[name] = method
	end

	for index, constructor in constructors do
		if typeof(index) ~= "number" then
			constructors[index] = nil
			table.insert(constructors, constructor)
		end
	end

	if readonly.ExtendedFrom and className ~= self.ClassName then
		readonly.ExtendedFrom ..= (", %s"):format(self.ClassName)
	elseif className ~= self.ClassName then
		readonly.ExtendedFrom = self.ClassName
	end

	return this
end

function baseClass:SetName(name: string)
	local instance = self.Instance
	if instance then
		instance.Name = name
	end

	data.workSpace[name] = util.GetNormalAccess(self)
	data.workSpace[self.Name] = nil
	self.Name = name
end

function baseClass:Destroy()
	local scene = data.restricted[self.Scene]
	local id = self.Id

	if self:IsA("EventEmitter") then
		self:Fire("Destroy")
	end

	if self.Instance then
		self.Instance:Destroy()
		data.workSpace[self.Name or ""] = nil
	end

	if scene then
		local environment = classEnvironments[self.ClassName or ""]
		scene = scene.readonly

		if scene.Objects then
			scene.Objects[id] = nil
		elseif environment then
			scene[environment]:RemoveOne(id)
		end
	end

	local restricted = data.restricted[id] or {}
	for _, dirName in directories do
		local dir = restricted[dirName]
		if not dir then
			continue
		end

		util.Delete(dir)
	end

	data.restricted[id] = nil

	table.clear(self)
	rawset(self, "Id", id)
end

function baseClass:IsA(className: string)
	return self.ExtendedFrom:match(className) or self.ClassName == className
end

return class.new("BaseClass", baseClass)

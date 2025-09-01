local upsideEngine = script.Parent.Parent.Parent
local appData = upsideEngine.AppData

local copyTable = require(upsideEngine.Lib.Util.Internal.CopyTable)
local eProperties = require(appData.EssentialProperties)
local data = require(appData.Data)

local environments = {
	"SoundEnvironment",
	"LightingEnvironment",
	"ParticleEnvironment",
	"ShaderEnvironment",
	"Objects",
}

local baseClass = {}
baseClass.__index = baseClass

local function set(self, clon, index)
	clon[index] = self[index]
end

function baseClass.new(): BaseClass
	local id = tostring(math.random()):split(".")[2]
	local self = {
		Id = id,
		ClassName = script.Name,
		ClassNameHistory = "",
		Name = "unamed-" .. id,
	}

	data.workSpace[self.Name] = self
	data.objects[id] = self

	return setmetatable(self, baseClass) :: any
end

function baseClass:Clone()
	local clon = self.new()
	local id = clon.Id
	local instance = clon.Instance

	copyTable(self, clon)
	clon.Instance = instance
	clon.Id = id

	for _, index in eProperties.Instance do
		pcall(set, self.Instance, clon.Instance, index)
	end

	return clon
end

function baseClass:SetName(name: string)
	local instance = self.Instance
	if instance then
		instance.Name = name
	end

	data.workSpace[name] = self
	data.workSpace[self.Name] = nil
	self.Name = name
end

function baseClass:Destroy()
	local scene = data.objects[self.Scene]
	local id = self.Id

	if self:IsA("EventEmitter") then
		self:Fire("Destroy")
	end

	if self.Instance then
		self.Instance:Destroy()
		data.workSpace[self.Name or ""] = nil
	end

	table.clear(self)
	if not scene then
		return
	end

	for _, environment in environments do
		local env = scene[environment]
		if not env:HasOne(id) then
			continue
		end

		env:RemoveOne(id)
	end
end

function baseClass:IsA(className: string)
	return self.ClassNameHistory:match(className) or self.ClassName == className
end

function baseClass:SetClassName(className)
	self.ClassName = className
	self.ClassNameHistory ..= className
end

return baseClass

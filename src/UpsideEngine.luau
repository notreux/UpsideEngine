local upsideEngine = script.Parent
local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)
local services = require(upsideEngine.Services)
local upsideWorkspace = require(upsideEngine.AppData.Data).workSpace

local constructor = {}
local methods = {}

function constructor:UpsideEngine()
	self.Services = services
	addReadonly({ Workspace = upsideWorkspace })
end

function methods:Create(name: string, ...)
	return self.Classes[name]:new(...)
end

function methods:GetService(name: string)
	return self.Services[name]
end

function methods:Extend(name: string, classData: ClassData)
	return self.Classes[name]:Extend(classData.name, classData)
end

return eventEmitter
	:Extend("UpsideEngine", {
		constructor = constructor,
		methods = methods,
		private = {
			Classes = {},
			Services = {},
		},
		readonly = {
			Version = "v1.0.2",
		},
	})
	:new()

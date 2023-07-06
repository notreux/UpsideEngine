local parent = script.Parent
local classes = {}

local services = require(parent.Services)
local upsideWorkspace = require(parent.AppData.Data).workSpace

local upsideEngine = {}
upsideEngine.Version = "v1.1.0"
upsideEngine.Workspace = upsideWorkspace

function upsideEngine.new(name: string)
	return function(data)
		return classes[name]:new(data)
	end
end

function upsideEngine.GetService(name: string)
	return services[name]
end

function upsideEngine.Extend(name: string)
	return function(classData)
		return classes[name]:Extend(classData.name, classData)
	end
end

for _, class in parent.Classes.Public:GetDescendants() do
	if class.Name:match(".spec") or not class:IsA("ModuleScript") then
		continue
	end

	classes[class.Name] = require(class)
end

return upsideEngine

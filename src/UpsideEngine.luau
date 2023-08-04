local parent = script.Parent
local classes = {}

local services = require(parent.Services)
local upsideWorkspace = require(parent.AppData.Data).workSpace

local upsideEngine = {}
upsideEngine.Version = "v1.1.0"
upsideEngine.Workspace = upsideWorkspace

function upsideEngine.new(name: string, data: any?)
	if data then
		return classes[name].new(data)
	end

	return function(data: any?)
		return classes[name].new(data)
	end
end

function upsideEngine.GetService(name: string)
	return services[name]
end

for _, class in parent.Classes.Public:GetDescendants() do
	if class.Name:match(".spec") or not class:IsA("ModuleScript") then
		continue
	end

	classes[class.Name] = require(class)
end

return upsideEngine

local parent = script.Parent
local classes = {}

local services = require(parent.Services)
local upsideWorkspace = require(parent.AppData.Data).workSpace

local upsideEngine = {}
upsideEngine.Version = "v3.0.1"
upsideEngine.Workspace = upsideWorkspace

function upsideEngine.new(name: string)
	return classes[name].new()
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

local types = require(script.Types)
local data = require(script.AppData.Data)

local runService = game:GetService("RunService")
local isServer = runService:IsServer()

local upsideEngine = require(script.UpsideEngine)
local restricted = data.restricted[upsideEngine.Id]

local function destroy()
	if isServer or not script.Private:FindFirstChild("Data") then
		return
	end
	script.AppData.Data:Destroy()
	script.Private.Class:Destroy()
end

local scripts = {
	public = script.Classes.Public:GetChildren(),
	main = script.Main:GetChildren(),
	runtime = script.Runtime:GetChildren(),
}

for dir, childs in scripts do
	for _, scr in ipairs(childs) do
		if scr.Name:match(".spec") then
			continue
		end

		if dir == "public" then
			restricted.private.Classes[scr.Name] = require(scr)
		elseif dir == "main" then
			restricted.readonly[scr.Name] = require(scr)
		elseif scr:IsA("ModuleScript") then
			coroutine.wrap(require)(scr)
		end
	end
end

for _, name in { "new", "Extend" } do
	data.restricted[upsideEngine.Id].methods[name] = nil
end

task.delay(0.1, destroy)
type upsideEngine = types.EventEmitter & {
	Version: string,
	Workspace: {},
	Create: ((self: upsideEngine, name: "PhysicalObject", ...any) -> types.PhysicalObject)
		& ((self: upsideEngine, name: "Sprite", ...any) -> types.Sprite)
		& ((self: upsideEngine, name: "Sound", ...any) -> types.Sound)
		& ((self: upsideEngine, name: "Environment", ...any) -> types.Environment)
		& ((self: upsideEngine, name: "Light", ...any) -> types.Light)
		& ((self: upsideEngine, name: "Character", ...any) -> types.Character)
		& ((self: upsideEngine, name: "Scene", ...any) -> types.Scene)
		& ((self: upsideEngine, name: "Particle", ...any) -> types.Particle)
		& ((self: upsideEngine, name: "Scene", ...any) -> types.Scene),

	GetService: ((self: upsideEngine, name: "SceneManager") -> types.SceneManager)
		& ((self: upsideEngine, name: "PluginSupportService") -> types.PluginSupportService)
		& ((self: upsideEngine, name: "NetworkingService") -> types.NetworkingService)
		& ((self: upsideEngine, name: "CrossPlatformService") -> types.CrossPlatformService),
}

return upsideEngine :: upsideEngine

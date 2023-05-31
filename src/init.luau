local types = require(script["init.d"])
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

data.restricted[upsideEngine.Id].methods["new"] = nil
task.delay(0.1, destroy)

return upsideEngine :: types.upsideEngine

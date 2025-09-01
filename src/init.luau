local types = require(script["init.d"])
local upsideEngine = require(script.UpsideEngine)

local runService = game:GetService("RunService")
local isServer = runService:IsServer()

local function destroy()
	if isServer or not script.Lib:FindFirstChild("Data") then
		return
	end
	script.AppData.Data:Destroy()
	script.Lib.Class:Destroy()
end

for _, scr in script.Runtime:GetChildren() do
	if scr.Name:match(".spec") or not scr:IsA("ModuleScript") then
		continue
	end

	coroutine.wrap(require)(scr)
end

task.delay(0.1, destroy)

export type ShadingParams = types.ShadingParams
return (upsideEngine :: any) :: types.upsideEngine

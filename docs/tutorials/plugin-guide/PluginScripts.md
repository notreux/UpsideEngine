Now you are ready to use the plugin, but you can't run the game only with the plugin, so you will need to import upside engine and also some code. 

## Import upside engine
Follow this steps to import upside engine

- Create a folder in ReplicatedStorage and then name it as "packages"
- Click on the button below to download the latest Upside Engine rbxm file
- Place the upside engine module in the packages folder

[Download Upside Engine](https://github.com/notreux/UpsideEngine/releases/latest/download/UpsideEngine.rbxm){ .md-button .md-basic-button }

## Essential code
Place this in StarterPlayerScripts as a local script to make your player move
```lua
------------- SETTINGS -------------
local sceneName = "MyScene" -- Change "MyScene" for your scene name
local characterName = "MyCharacter" -- Change "MyCharacter" for your character name
local isPlatformer = true -- Change this to false if your game is not a platformer
------------------------------------
local replicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local packages = replicatedStorage:WaitForChild("packages")
local upsideEngine = require(packages:WaitForChild("UpsideEngine"))

local sceneManager = upsideEngine.GetService("SceneManager")
local crossPlatformService = upsideEngine.GetService("CrossPlatformService")
local pluginSupportService = upsideEngine.GetService("PluginSupportService")
pluginSupportService:LoadPluginContent()

local scene = sceneManager:FindByName(sceneName)
local character = scene.Objects:FindByName(characterName)

crossPlatformService.SideView = isPlatformer
crossPlatformService:SetPlayerCharacter(character)
scene.Camera:SetSubject(character)
scene:Enable()

local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
scene.Instance.Parent = screenGui
```

___
##### Congratulations! you are true master of upside engine 🎉🎉!!

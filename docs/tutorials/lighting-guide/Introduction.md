# Lighting Guide

In this tutorial, we will walk through how to set up a dynamic lighting system in a Roblox game using UpsideEngine. The guide is divided into three sections:

1. **Introduction**
2. **Pointlight**
3. **Spotlight**

---

## Introduction

In the introduction section, we set up the basic scene using UpsideEngine. This includes fetching essential services, initializing the scene, and configuring the lighting environment.

```lua
local RunService = game:GetService("RunService")  
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")  
local UpsideEngine = require(game.ReplicatedStorage:WaitForChild("UpsideEngine"))  

local SceneManager = UpsideEngine.GetService("SceneManager")  
local NetworkingService = UpsideEngine.GetService("NetworkingService")  
local CrossPlatformService = UpsideEngine.GetService("CrossPlatformService")  
CrossPlatformService.SideView = true  

local mouse = game.Players.LocalPlayer:GetMouse()  
local scene = UpsideEngine.new("Scene")  
scene.Instance.Parent = PlayerGui:WaitForChild("Game")  
scene:Enable()

-- Only visible lights will be tracked
scene.OnlyTrackVisible = true  

-- Set the ambient color of the lighting environment to black
scene.LightingEnvironment.AmbientColor = Color3.fromRGB(0, 0, 0)  

-- Define the ambient transparency; lower values mean less transparency
scene.LightingEnvironment.AmbientTransparency = 0.02 

-- Set the resolution of each chunk (tile) in the lighting environment to 64x64 pixels
scene.LightingEnvironment.ChunkResolution = Vector2.new(64, 64)  

-- Specify that there will be 1 column of chunks in the lighting environment
scene.LightingEnvironment.ChunkColumns = 1  

-- Choose the light resampling mode; Pixelated provides a retro, blocky look.
-- You can alternatively use Enum.ResamplerMode.Default for smoother results.
scene.LightingEnvironment.LightStyle = Enum.ResamplerMode.Pixelated  
scene.LightingEnvironment:DrawPixels()  
```

**Explanation:**  

- We retrieve essential services such as RunService, PlayerGui, and the UpsideEngine module.  
- The scene is created and parented to the "Game" GUI element.  
- Lighting environment parameters are configured to achieve a pixelated, retro style.

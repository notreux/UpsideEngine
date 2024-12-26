On this page, you will learn how a shader is created and how to assign it to your objects. 
To start Let's create a new script `guide.client.luau` in which we will place this code:

## A basic setup

Let's begin by setting up the essentials. We'll create a scene that will be our main workspace for building and refining our project in this guide.
```lua
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local packages = replicatedStorage.packages
local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")

local upsideEngine = require(packages.UpsideEngine)
local screen = Instance.new("ScreenGui")
screen.Name = "Screen"
screen.IgnoreGuiInset = true
screen.Parent = playerGui

local scene = upsideEngine.new("Scene")
scene.Instance.Parent = screen
scene:SetName("MyScene") 
scene:Enable()
```

## Assets
Roblox only allows you to modify the images uploaded by the owner of the experience, so you will have to download the assets we will work with in this guide.

![](../../assets/camera.png){ width="128" height="128" .pixelated}
![](../../assets/water.png){ .pixelated }
![](../../assets/terrain.png){ .pixelated }

## Creating our shader
First, we need to create a new Module Script that returns a function. Let's name it `Shader.luau`.

```lua
return function()
    -- shader code
end
```

Now, back in our main script "guide.client.luau", let's create the shader:

```lua
local shader = upsideEngine.new("Shader")
shader:SetSource(script.Parent.Shader) -- we set the shader source in the module script created previously
```

Next, let's create an object to apply our shader to:

```lua
local water = upsideEngine.new("StaticObject")
water:SetScene(scene)
water:SetShader(shader)

local instance = water.Instance
instance.Image = "rbxassetid://waterId"
instance.Size = UDim2.fromOffset(800, 800)
```

Let's add some decoration too:
```lua
local terrain = upsideEngine.new("StaticObject")
terrain:SetScene(scene)

local instance = terrain.Instance
instance.Image = "rbxassetid://terrainId"
instance.Size = UDim2.fromOffset(800, 800)
```
___
##### Good job, you finished the first steps to create a shader!
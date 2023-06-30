# Creating the Player Character
To create the player character, we will need to create a new Luau file named `character.luau` in the `src/client` folder and add the following code:

```lua
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local packages = replicatedStorage.packages

local upsideEngine = require(packages.UpsideEngine)
local sceneManager = upsideEngine:GetService("SceneManager")
local crossPlatformService = upsideEngine:GetService("CrossPlatformService")

local scene = sceneManager:FindByName("MyFirstScene")
local spawn_position = UDim2.fromOffset(350, 800)
local player = upsideEngine:Create("Character", scene, Vector2.new(37, 64))
player.Anchored = false
player:SetSpriteSheet("idle", "rbxassetid://12908048527", Vector2.new(12, 1))
player:SetSpriteSheet("right", "rbxassetid://12908048527", Vector2.new(12, 1))
player:SetSpriteSheet("jump", "rbxassetid://12908048527", Vector2.new(12, 1))
player:SetSpriteSheet("left", "rbxassetid://12970115106", Vector2.new(12, 1))
player:Set({
	Position = spawn_position,
	Size = UDim2.fromOffset(128, 128),
	ZIndex = 4,
})
```
This code creates a new character object in the game's scene using the Upside Engine framework. The character object is stored in a variable named "player".

## Adding Animations
!!! tip
	Some words like "idle", "left" or "jump" can be played automatically by CrossPlatformService, which means that it is not necessary to play them if `CrossPlatformService.DefaultControllersEnabled` is set to true.

We can add animations to our player character using sprite sheets.
```lua
player:SetSpriteSheet("idle", "rbxassetid://12908048527", Vector2.new(1, 12))
```

This sets the sprite sheet for the "idle" animation, using the ID of the asset and also pass the number of rows and columns as a Vector2, for example we have 5 frames in the in two lines, the expected Vector2 would be `Vector2.new(2, 5)`.

## Adding Player Controllers
To add player controllers, we need to use the CrossPlatformService:

```lua
local crossPlatformService = upsideEngine:GetService("CrossPlatformService")
crossPlatformService:SetSubject(player)
```
This sets the player character as the subject of the CrossPlatformService, allowing for control inputs to be applied to the character

___
##### Congratulations! You've now created your first player character using Upside Engine 🎉🎉 
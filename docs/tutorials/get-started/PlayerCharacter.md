# Creating the Player Character
To create the player character, we will need to create a new script named `character.luau` in the `src/client` folder and add the following code:

```lua
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local packages = replicatedStorage.packages

local upsideEngine = require(packages.UpsideEngine)
local sceneManager = upsideEngine.GetService("SceneManager")
local crossPlatformService = upsideEngine.GetService("CrossPlatformService")

local scene = sceneManager:FindByName("MyFirstScene")
local spawn_position = UDim2.fromOffset(350, 800)

local player = upsideEngine.new("Character")
player.Anchored = false
player.JumpPower = 100
player:SetScene(scene)
player:SetSpriteSheet("idle_right", "rbxassetid://12908048527", Vector2.new(12, 1))
player:SetSpriteSheet("idle_left", "rbxassetid://12908048527", Vector2.new(12, 1))
player:SetSpriteSheet("right", "rbxassetid://12908048527", Vector2.new(12, 1))
player:SetSpriteSheet("up", "rbxassetid://12908048527", Vector2.new(12, 1))
player:SetSpriteSheet("left", "rbxassetid://12970115106", Vector2.new(12, 1))

local plrInstance = player.Instance
plrInstance.ZIndex = 2
plrInstance.ImageRectSize = Vector2.new(37, 64)
plrInstance.Size = UDim2.fromOffset(100, 100)
```
This code creates a new character object in the game's scene using the Upside Engine framework. The character object is stored in a variable named "player".

## Adding Animations
!!! tip
	Some words like "idle_right", "idle_left", "left" or "up" can be played automatically by CrossPlatformService, which means that it is not necessary to play them if `CrossPlatformService.DefaultControllersEnabled` is set to true.

As we saw in the previous code example, we can add animations to our player character using sprite sheets.
```lua
player:SetSpriteSheet("idle_right", "rbxassetid://12908048527", Vector2.new(1, 12))
```

This sets the sprite sheet for the "idle" animation, using the ID of the asset and also pass the number of rows and columns as a Vector2, for example we have 5 frames in the in two lines, the expected Vector2 would be `Vector2.new(2, 5)`.

## Adding Player Controllers
To add player controllers, we need to use the CrossPlatformService which was required in the previously:

```lua
crossPlatformService:SetPlayerCharacter(player)
```
This sets the player character as the subject of the CrossPlatformService, allowing for control inputs to be applied to the character

## Camera Setup
To make the camera follow the character, we will need to define the player as the camera subject. We can achieve this by using the following code:

```lua
scene.Camera:SetSubject(player)
```

## Avoid infinity fall
To avoid that when our character falls, it stays falling infinitely, we will use the following code:

```lua
runService.Heartbeat:Connect(function()
	local instance = player.Instance
	if instance.Position.Y.Offset < 1000 then
		return
	end

	instance.Position = spawn_position
end)
```
___

!!! bug
	Remember that you are using a module script, don't forget to return a value at the end of the script!
	```lua
	return {}
	```

___
##### Congratulations! You've now created your first player character using Upside Engine 🎉🎉 
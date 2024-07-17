# Client Side
To create a multiplayer game we will need to [import](../get-started/Installation.md) upside engine.

## A basic setup
Let's do a basic setup of our multiplayer game game

```lua
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")

local upsideEngineModule = game.ReplicatedStorage:WaitForChild("UpsideEngine")
local upsideEngine = require(upsideEngineModule)

local sceneManager = upsideEngine.GetService("SceneManager")
local crossPlatformService = upsideEngine.GetService("CrossPlatformService")
local networkingService = upsideEngine.GetService("NetworkingService")

local screen = Instance.new("ScreenGui")
screen.Name = "MultiplayerGame"
screen.IgnoreGuiInset = true
screen.Parent = playerGui

local scene = upsideEngine.new "Scene"
scene.Instance.Parent = screen
scene:Enable()

```

## Creating the scenario
Let's create a basic scenario for our players
```lua
local Terrain = upsideEngine.new "PhysicalObject"
Terrain:SetScene(scene)

local terrInstance = Terrain.Instance
terrInstance.Visible = true
terrInstance.Position = UDim2.fromOffset(0, 0)
terrInstance.Size = UDim2.fromOffset(600, 160)
terrInstance.Image = "rbxassetid://12980969571"
```

## Creating the character
Let's create our player character
```lua
local character = upsideEngine.new "Character"
character.Anchored = false
character.CanCollide = true
character:SetScene(scene)
character:SetName(game.Players.LocalPlayer.Name)
character:SetSpriteSheet("idle", "rbxassetid://12908048527", Vector2.new(12, 1 ))
character:Play("idle")

local charInstance = character.Instance
charInstance.ImageRectSize = Vector2.new(37.35, 37.35)
charInstance.Position = UDim2.fromOffset(0, -1000)
charInstance.Size = UDim2.fromOffset(100, 100)

crossPlatformService:SetPlayerCharacter(character)
scene.Camera:SetSubject(character)
```

## Client replication
As the name say, when we use `:ReplicateOnChange()`, the object will be replicated if some of his properties change. 

Events information:

- The `ReplicationRequest` event is fired every time that an object from other client replicates an object
- The `Build` event is fired when a request is accepted and the object to replicate never was replicated before

```lua
networkingService:ReplicateOnChange(character)
networkingService:On("Build", function(object)
	-- Its recomended to unanchor the object, it will make the movement smoother
	-- that's because the Anchor property is not replicated by default
	object.Anchored = false
	object:SetScene(scene)
end)

networkingService:On("ReplicationRequest", function(request)
	request:Accept() -- It returns the replicated object
end)
```
___
##### Congratulations you finished the replication tutorial in the client side, Let's see next page 🎉🎉
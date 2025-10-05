# Client Setup

Now that you understand how replication works, let's set up the client side of your multiplayer game.

## Basic client structure

Here's a complete client setup with all the essentials:

```lua title="Client Script"
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Load Upside Engine
local UpsideEngine = require(packages.UpsideEngine)

-- Get required services
local networkingService = UpsideEngine.GetService("NetworkingService")
local crossPlatformService = UpsideEngine.GetService("CrossPlatformService")

-- Create the screen container
local screen = Instance.new("ScreenGui")
screen.Name = "MultiplayerGame"
screen.IgnoreGuiInset = true
screen.Parent = playerGui

-- Create and configure the scene
local scene = UpsideEngine.new("Scene")
scene.Instance.Parent = screen
scene:SetName("GameScene")
scene:Enable()
```

## Creating the game environment

Let's create a simple environment for our game:

```lua title="Create Terrain"
-- Create a terrain/background
local terrain = UpsideEngine.new("StaticObject")
terrain:SetScene(scene)

local terrainInstance = terrain.Instance
terrainInstance.Position = UDim2.fromOffset(0, 0)
terrainInstance.Size = UDim2.fromOffset(800, 800)
terrainInstance.Image = "rbxassetid://yourTerrainId"
terrainInstance.ZIndex = 1
```

## Creating your player character

Now let's create the player character that will be replicated:

```lua title="Create Character"
local character = UpsideEngine.new("Character")
character:SetScene(scene)

-- Basic properties
local size = 256
character.Instance.Position = UDim2.fromOffset(400, 300)
character.Instance.Size = UDim2.fromOffset(size, size)
character.Instance.ImageRectSize = Vector2.new(64, 64)
character.Instance.ZIndex = 100

-- Physics properties
character.Mass = 0
character.WalkSpeed = 200
character.SecondsPerFrame = 1 / 10

-- Set up sprite sheets for different animations
character:SetSpriteSheet("idle_down", "rbxassetid://yourIdleDownId", Vector2.new(4, 1))
character:SetSpriteSheet("walk_down", "rbxassetid://yourWalkDownId", Vector2.new(4, 1))
character:SetSpriteSheet("idle_up", "rbxassetid://yourIdleUpId", Vector2.new(4, 1))
character:SetSpriteSheet("walk_up", "rbxassetid://yourWalkUpId", Vector2.new(4, 1))
-- Add more sprite sheets as needed...

-- Start with an idle animation
character:Play("idle_down")

-- Configure player controls and camera
crossPlatformService.SideView = false
crossPlatformService:SetPlayerCharacter(character)
scene.Camera:SetSubject(character)
```

## Setting up replication

Now comes the important part - telling Upside Engine to replicate this character:

```lua title="Enable Replication"
-- Start replicating the character
-- This will send replication data to the server
networkingService:ReplicateOnChange(character)
```

!!! info "What happens when you call `ReplicateOnChange()`?"
    1. The object's initial state is sent to the server as a `ReplicationRequest`
    2. The server must accept it with `request:Accept()` to create the object
    3. The server should grant authority with `SetAuthority(object, "Client")`
    4. Once authority is granted, every property change sends a new `ReplicationRequest`
    5. The server must call `Accept()` on each request to apply the changes
    6. You don't need to manually trigger updates - they happen automatically!

## Handling other players' characters

When other players join, their characters need to be displayed on your client:

```lua title="Handle Build Event"
-- The Build event fires when an object from another player is created on your client
networkingService:On("Build", function(object)
    -- Add the object to your scene so it becomes visible
    object:SetScene(scene)
    
    -- You can also do additional setup here if needed
    -- For example, you might want to set a specific ZIndex or configure visuals
end)
```

!!! tip "Important notes about the Build event"
    - Fires once per object when it's first created on your client
    - The object is already fully created, you just need to add it to your scene
    - Some properties might not be replicated (this depends on the property type)

## Complete client example

Here's a complete working example:

```lua title="Complete Client Script"
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packages = ReplicatedStorage.Packages
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local UpsideEngine = require(packages.UpsideEngine)
local networkingService = UpsideEngine.GetService("NetworkingService")
local crossPlatformService = UpsideEngine.GetService("CrossPlatformService")

-- Setup screen and scene
local screen = Instance.new("ScreenGui")
screen.Name = "MultiplayerGame"
screen.IgnoreGuiInset = true
screen.Parent = playerGui

local scene = UpsideEngine.new("Scene")
scene.Instance.Parent = screen
scene:Enable()

-- Create environment
local terrain = UpsideEngine.new("StaticObject")
terrain:SetScene(scene)
terrain.Instance.Position = UDim2.fromOffset(0, 0)
terrain.Instance.Size = UDim2.fromOffset(800, 800)
terrain.Instance.Image = "rbxassetid://yourTerrainId"

-- Create player character
local character = UpsideEngine.new("Character")
character:SetScene(scene)
character.Instance.Position = UDim2.fromOffset(400, 300)
character.Instance.Size = UDim2.fromOffset(256, 256)
character.Instance.ImageRectSize = Vector2.new(64, 64)
character.Mass = 0
character.WalkSpeed = 200

character:SetSpriteSheet("idle", "rbxassetid://yourIdleId", Vector2.new(4, 1))
character:Play("idle")

crossPlatformService.SideView = false
crossPlatformService:SetPlayerCharacter(character)
scene.Camera:SetSubject(character)

-- Start replication
networkingService:ReplicateOnChange(character)

-- Handle other players' characters
networkingService:On("Build", function(object)
    object:SetScene(scene)
end)
```

## What gets replicated?

Not all properties are replicated automatically. The replication system only syncs properties marked as `Replicable`. Common replicated properties include:

- Position
- Size
- Rotation
- Velocity
- Active sprite sheet
- Custom properties you define

Properties like visual effects, some physics properties, or local-only data might not be replicated.

## Best practices

!!! success "Best Practices"
    1. **Create objects on the client**: Each player should create their own character locally
    2. **Call ReplicateOnChange() immediately**: Start replication as soon as the object is ready
    3. **Keep the Build handler simple**: Just add objects to the scene, don't do heavy processing
    4. **Don't replicate everything**: Only replicate objects that other players need to see

---

**Next:** [Server Setup](ServerSetup.md)

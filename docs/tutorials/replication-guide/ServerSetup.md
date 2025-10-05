# Server Setup

The server plays a crucial role in replication - it validates requests, manages authority, and distributes updates to all clients. Let's set up a proper server for your multiplayer game.

## Understanding server replication

Before we dive into the code, it's important to understand two types of replication:

!!! info "Replication Types"
    1. **Client-to-Server replication**: When clients create objects (like player characters) and want to share them with other players, they use `ReplicateOnChange()`. The server receives `ReplicationRequest` events and must accept them.

    2. **Server-to-Clients replication**: When the server creates objects (like NPCs, world objects, etc.), they automatically replicate to all clients. No `ReplicateOnChange()` needed - it's automatic!

This guide focuses on handling client-to-server replication requests.

## Basic server structure

Here's a minimal server setup:

```lua title="Basic Server Script"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UpsideEngine = require(ReplicatedStorage.Packages.UpsideEngine)
local networkingService = UpsideEngine.GetService("NetworkingService")
local authorityService = UpsideEngine.GetService("AuthorityService")

-- Handle replication requests from clients
networkingService:On("ReplicationRequest", function(request)
    -- Accept the request and create the object
    local object = request:Accept()
    
    -- CRITICAL: Grant authority to the client
    -- Without this, the client won't be able to update the object!
    authorityService:SetAuthority(object, "Client")
end)
```

!!! success "That's It!"
    **This is all you need for basic multiplayer functionality!**

## Understanding the request object

The `request` parameter contains important information:

```lua title="Request Object Properties"
networkingService:On("ReplicationRequest", function(request)
    -- Get information about the request
    local clientId = request.ClientId        -- The UserId of the player
    local content = request.Content          -- Information about the object
    local className = content.ClassName      -- Type of object ("Character", "StaticObject", etc.)
    local instance = content.Instance        -- The Roblox instance data
    
    -- Accept the request
    local object = request:Accept()
end)
```

## Why you must set authority

Let me explain why setting authority is critical with a comparison:

=== "❌ Without authority assignment"

    ```lua
    networkingService:On("ReplicationRequest", function(request)
        request:Accept()
        -- Server now has authority
    end)
    ```

    **What happens:**
    
    1. :white_check_mark: Client sends first replication → `ReplicationRequest` fires → Object created
    2. :x: Client moves → No `ReplicationRequest` sent (server has authority)
    3. :x: `ReplicationRequest` event never fires again
    4. :x: Other players see a frozen character
    5. :x: Only the local player sees movement (not synchronized)

=== "✅ With authority assignment"

    ```lua
    networkingService:On("ReplicationRequest", function(request)
        local object = request:Accept()
        authorityService:SetAuthority(object, "Client")
        -- Client now has authority
    end)
    ```

    **What happens:**
    
    1. :white_check_mark: Client sends first replication → `ReplicationRequest` fires → Object created + Authority granted
    2. :white_check_mark: Client moves → `ReplicationRequest` fires again with new position
    3. :white_check_mark: Server calls `Accept()` → Changes applied and distributed to all clients
    4. :white_check_mark: Every property change → New `ReplicationRequest` → You accept it
    5. :white_check_mark: All players see smooth synchronized movement

!!! danger "The key point"
    - When the server calls `request:Accept()` on the first request, it automatically takes authority
    - Without client authority: `ReplicationRequest` fires **only once** (object creation)
    - With client authority: `ReplicationRequest` fires **every time the client changes a property**
    - You must call `Accept()` on each request to apply the changes

## Tracking players and their objects

A better approach is to keep track of each player's objects:

```lua title="Enhanced Server Script with Tracking"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UpsideEngine = require(ReplicatedStorage.Packages.UpsideEngine)
local networkingService = UpsideEngine.GetService("NetworkingService")
local authorityService = UpsideEngine.GetService("AuthorityService")

-- Store each player's character
local characters = {}

networkingService:On("ReplicationRequest", function(request)
    local content = request.Content
    local player = Players:GetPlayerByUserId(request.ClientId)
    
    -- Check if this is a character
    if content.ClassName == "Character" then
        local character = request:Accept()
        
        -- Only grant authority if this is a new character for this player
        if not characters[player] then
            authorityService:SetAuthority(character, "Client")
            characters[player] = character
            
            print(player.Name .. "'s character replicated successfully")
        end
    else
        -- For other object types, accept and grant authority
        local object = request:Accept()
        authorityService:SetAuthority(object, "Client")
    end
end)

-- Clean up when players leave
Players.PlayerRemoving:Connect(function(player)
    characters[player] = nil
    print(player.Name .. " left the game")
end)
```

## Managing the scene on the server

You can also set up a scene on the server for server-side logic:

```lua title="Server Scene Setup"
local sceneManager = UpsideEngine.GetService("SceneManager")
local scene = sceneManager:FindByName("game") -- Find your scene

-- Wait for the scene to be ready
while not scene do
    scene = sceneManager:FindByName("game")
    task.wait()
end

-- Now you can do server-side operations
print("Server scene is ready!")
```

## Complete server example

Here's a complete, production-ready server setup:

```lua title="Complete Server Script"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UpsideEngine = require(ReplicatedStorage.Packages.UpsideEngine)
local networkingService = UpsideEngine.GetService("NetworkingService")
local authorityService = UpsideEngine.GetService("AuthorityService")
local sceneManager = UpsideEngine.GetService("SceneManager")

-- State tracking
local characters = {}
local scene = nil

-- Initialize server
local function initialize()
    -- Find the game scene
    scene = sceneManager:FindByName("game")
    while not scene do
        scene = sceneManager:FindByName("game")
        task.wait()
    end
    
    print("Server initialized successfully")
end

-- Handle replication requests
networkingService:On("ReplicationRequest", function(request)
    local content = request.Content
    local player = Players:GetPlayerByUserId(request.ClientId)
    
    if not player then
        print("Warning: Received request from unknown player")
        return
    end
    
    -- Accept the object
    local object = request:Accept()
    
    -- Handle different object types
    if content.ClassName == "Character" then
        -- Track the player's character
        if not characters[player] then
            authorityService:SetAuthority(object, "Client")
            characters[player] = object
            print(player.Name .. " joined the game")
        end
    else
        -- For other objects, grant authority
        authorityService:SetAuthority(object, "Client")
    end
end)

-- Handle player disconnections
Players.PlayerRemoving:Connect(function(player)
    characters[player] = nil
    print(player.Name .. " left the game")
end)

-- Start the server
initialize()
```

## Important notes

!!! warning "ReplicationRequest Behavior"
    1. **ReplicationRequest behavior depends on authority**: 
       - Without client authority: Fires **once** (object creation only)
       - With client authority: Fires **on every property change**

    2. **You must accept every request**: Call `request:Accept()` on every `ReplicationRequest` to apply the changes

    3. **Authority must be set on the first request**: Call `SetAuthority()` after accepting the first request to enable continuous replication

    4. **Server has authority by default**: After calling `request:Accept()` on the first request, the server automatically takes authority

    5. **Don't reject requests unnecessarily**: Every time you don't call `Accept()`, those changes are discarded

## What about validation?

You might be wondering: "Should I validate player positions or check for exploits?"

!!! tip "Validation Guidelines"
    While you *can* add validation, it's often better to:
    
    - Trust the client for basic movement
    - Use the authority system to prevent unauthorized modifications
    - Implement server-side validation only for critical actions (damage, item pickup, etc.)
    - Consider player experience - aggressive validation can cause lag or false positives

If you need validation, do it for specific actions using RemoteEvents, not for every position update.

---

**Next:** [Authority System](AuthoritySystem.md)

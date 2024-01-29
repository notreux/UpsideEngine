# Server Side
When an object is replicated, a request is sent to the server, every time this happens the `ReplicationRequest` event is fired on the server side, here the server can perform some security checks if you want.

## Without security checks
```lua
local replicatedStorage = game:GetService("ReplicatedStorage")
local upsideEngineModule = replicatedStorage:WaitForChild("UpsideEngine")

local upsideEngine = require(upsideEngineModule)
local networkingService = upsideEngine.GetService("NetworkingService")

networkingService:On("ReplicationRequest", function(request)
    request:Approve()
end)
```

## With security checks
In this example we check how much the player's character has moved since the last replication, doing this we can detect if the player is using exploits.
```lua
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local upsideEngineModule = replicatedStorage:WaitForChild("UpsideEngine")
local upsideEngine = require(upsideEngineModule)

local networkingService = upsideEngine.GetService("NetworkingService")
local pastPositions = {}

networkingService:On("ReplicationRequest", function(request)
	local instance = request.Content.Instance
    local clientId = request.ClientId

    local currentPosition = Vector2.new(instance.Position.X.Offset, instance.Position.Y.Offset)
	local previousPosition = pastPositions[clientId] or Vector2.zero

    local distance = (currentPosition - previousPosition).Magnitude
    pastPositions[clientId] = currentPosition

    if distance < 500 then
        request:Approve()
        return
    end

    -- The player is moving faster than expected, so is probably exploiting
    -- maybe players with lag can have false positives, so be carefull with the distance check

    local player = players:GetPlayerByUserId(clientId)
    player:Kick("please don't exploit")
end)
```
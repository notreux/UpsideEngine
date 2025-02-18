# Module Structure
On this page, you will learn the recommended approach to structuring modules, which will enable us to develop in a more scalable and user-friendly manner.

## Structure
```lua
-- imports
local exports = {}
function exports.load(scene: Scene)
	-- initialization code
end

function exports.start(scene: Scene)
	-- code to run once everything is ready
end

function exports.unload(scene: Scene)
	-- code to run before the scene is unloaded
end

return exports
```

## The Benefits of This Structure
This organization ensures that all objects you intend to use are properly initialized. For instance, if you call something like `scene.Objects:FindByName("Dog")` before the object has been created, it could lead to an error. By initializing everything in the `load` function and then using them in the `start` function, we guarantee that all required elements are ready as expected. Additionally, the `unload` function is executed when a scene is unloaded, making it the perfect place to handle scene transitions safely.

!!! example "`client/modules/myScene/character.luau`"
    ```lua
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local runService = game:GetService("RunService")
    local packages = replicatedStorage:WaitForChild("packages")

    local upsideEngine = require(packages.UpsideEngine)
    local crossPlatformService = upsideEngine.GetService("CrossPlatformService")

    local exports = {}
    function exports.load(scene: Scene)
        local character = upsideEngine.new("Character")
        character.JumpPower = 100
        character:SetScene(scene)
        character:SetSpriteSheet("idle", "rbxassetid://12908048527", Vector2.new(12, 1))
        character:SetSpriteSheet("right", "rbxassetid://12908048527", Vector2.new(12, 1))
        character:SetSpriteSheet("jump", "rbxassetid://12908048527", Vector2.new(12, 1))
        character:SetSpriteSheet("left", "rbxassetid://12970115106", Vector2.new(12, 1))
        
        local plrInstance = character.Instance
        plrInstance.ZIndex = 2
        plrInstance.ImageRectSize = Vector2.new(37, 64)
        plrInstance.Size = UDim2.fromOffset(100, 100)
        
        crossPlatformService:SetPlayerCharacter(character)
        scene.Camera:SetSubject(character)
        
        character:Play("idle")
        exports.character = character
    end

    function exports.start(scene: Scene)
        local spawnPosition = UDim2.fromOffset(350, 800)
        local character = exports.character
        local instance = character.Instance

        -- Avoid infinite fall
        exports.connection = runService.Heartbeat:Connect(function()
            local yPosition = instance.Position.Y.Offset
            if yPosition >= 1000 then
                instance.Position = spawnPosition
            end
        end)
    end

    function exports.unload()
        exports.connection:Disconnect()
    end

    return exports
    ```
# Module Management
On this page, you will learn what code should be placed in `setup.luau`, `main.client.luau`, 
and `main.server.luau` to ensure a smooth, scalable initialization of your project’s modules. 
This structure allows you to organize your code effectively, enabling dynamic module loading, 
scene management, and proper cleanup when needed.

## Utilities
The purpose of the `shared/util/setup.luau` script is to provide utility functions that will later 
be used in both `main.client.luau` and `main.server.luau`. This script offers methods for retrieving 
modules by their path and for running specified methods (such as load, start, or unload) on those 
modules. By centralizing these common operations, you ensure consistency and simplify module 
management across the project.

???+ example "`shared/util/setup.luau`"
    ```lua
    local exports = {}

    --[[
        Retrieves all ModuleScripts from a given path and requires them.
        Returns a table mapping module names to the required module. 
    ]] 
    function exports.getModulesByPath(path)
        local modules = {}
        for _, module in path:GetChildren() do
            if module:IsA("ModuleScript") then
                modules[module.Name] = require(module)
            end
        end

        return modules
    end

    --[[
        Iterates over a table of modules and calls the specified method on each,
        passing any additional arguments provided.
    ]] 
    function exports.run(modules, methodName, ...)
        for _, module in modules do
            if module[methodName] then
                module[methodName](...)
            end
        end
    end

    return exports
    ```

## Client Side
On the client side, the main script is responsible for setting up modules and managing 
scene transitions. The `client/main.client.luau` file loads the modules that are either 
global or scene-specific. When a new scene is loaded, it unloads the modules from the 
previous scene and loads the new ones accordingly. This dynamic approach ensures that 
only the necessary modules are active, improving performance and reducing conflicts.
???+ example "`client/main.client.luau`"
    ```lua
    local players = game:GetService("Players")
    local replicatedStorage = game:WaitForChild("ReplicatedStorage")
    local packages = replicatedStorage:WaitForChild("packages")
    local modules = script.Parent:WaitForChild("modules")
    local setup = require(replicatedStorage.shared.util.setup)
    local upsideEngine = require(packages:WaitForChild("upsideEngine"))

    local pluginSupportService = upsideEngine.GetService("PluginSupportService")
    local sceneManager = upsideEngine.GetService("SceneManager")

    -- Load global modules that are used across multiple scenes.
    local globalModules = setup.getModulesByPath(modules:WaitForChild("globals"))
    local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")
    local activeScene = nil

    local sceneContainer = Instance.new("ScreenGui")
    sceneContainer.Name = "SceneContainer"
    sceneContainer.Parent = playerGui

    -- Unload modules from the current scene.
    local function unloadModules(scene)
        local path = modules:WaitForChild(scene.Name)
        local sceneModules = setup.getModulesByPath(path)

        setup.run(globalModules, "unload")
        setup.run(sceneModules, "unload")
    end

    -- Load and start modules for the new scene.
    local function loadModules(scene)
        local path = modules:WaitForChild(scene.Name)
        local sceneModules = setup.getModulesByPath(path)
        activeScene = scene

        setup.run(globalModules, "load", scene)
        setup.run(sceneModules, "load", scene)

        setup.run(globalModules, "start", scene)
        setup.run(sceneModules, "start", scene)
    end

    -- Listen for scene changes and reload modules accordingly.
    sceneManager:On("SceneLoaded", function(scene)
        if activeScene then
            unloadModules(activeScene)
            activeScene:Disable()
            activeScene.Parent = nil
        end

        activeScene = scene
        scene.Parent = sceneContainer
        loadModules(scene)
    end)

    -- Load scenes from the plugin if they were created using it.
    pluginSupportService:LoadPluginContent()
    local myPluginScene = sceneManager:FindByName("MyScene")
    myPluginScene:Enable()

    -- Alternatively, create and enable a new scene programmatically.
    local newScene = upsideEngine.new("Scene")
    newScene:SetName("MyNewScene")
    newScene:Enable()
    ```

## Server Side
On the server side, module management is typically more straightforward. The `server/main.server.luau` 
script is tasked with loading the necessary modules when the game starts and ensuring they are properly 
unloaded when the game closes. This helps maintain a clean server state and prevents issues during shutdown.
???+ example "`server/main.server.luau`"
    ```lua
    local replicatedStorage = game:WaitForChild("ReplicatedStorage")
    local setup = require(replicatedStorage.shared.util.setup)
    local modules = setup.getModulesByPath(script.Parent:WaitForChild("modules"))

    -- Unload all modules when required.
    local function unloadModules()
        setup.run(modules, "unload")
    end

    -- Load and start all server-side modules.
    local function loadModules()
        setup.run(modules, "load")
        setup.run(modules, "start")
    end

    -- Load modules
    loadModules()

    -- Ensure that modules are unloaded properly when the game is closing.
    game:BindToClose(function()
        unloadModules()
    end)
    ```

## Template
Additionally, click on the button below to visit the GitHub repository containing the complete template 
that encompasses everything discussed on this page. We encourage you to explore the repository and use the template as a robust starting point for your own development work.

[Get template](https://github.com/notreux/UpsideEngineProjectTemplate){ .md-button .md-basic-button }
[Get Demo](https://github.com/notreux/SpaceFighter){ .md-button .md-basic-button }
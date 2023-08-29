# Installation

!!! warning
    Please be aware that this guide requires the use of Github submodules and Rojo. Before proceeding, make sure that you have initialized a Git repository and are using the Rojo template.

To install the Upside Engine Framework, use the following command to create a new folder named "packages" with the Upside Engine Framework inside:

```git
git submodule add https://github.com/TheHackerPuppy/UpsideEngine packages/UpsideEngine
```

??? Download-for-roblox-studio

    !!! warning inline end 
        This tutorial is oriented to an external editor so might you have some problems following the tutorial if you use roblox studio to code

    If you don't use an external editor and you just prefer to program directly on roblox follow please these steps:

     - Create a folder in ReplicatedStorage and then name it as "packages"
     - Place the upside engine module in the packages folder

    Download the upside engine module script clicking on the button below 

    [Download](https://create.roblox.com/marketplace/asset/6178021458){ .md-button .md-basic-button }



## Recommended Rojo Template

To install the Upside Engine Framework, use the following command to create a new folder named "packages" with the Upside Engine Framework inside:

???+ info 
    ```json
    {
       "name": "My first 2D Game",
        "tree": {
            "$className": "DataModel",
            "ReplicatedStorage": {
                "$className": "ReplicatedStorage",
                "packages": {
                    "$className": "Folder",
                    "$path": "packages"
                }
            },
        
            "StarterPlayer": {
                "$className": "StarterPlayer",
                "StarterPlayerScripts": {
                    "$className": "StarterPlayerScripts",
                    "client":{
                        "$path": "src/client"
                    }
                }
            },

            "ServerScriptService": {
                "$className": "ServerScriptService",
                "server": {
                    "$path":"src/server"
                }
            }
        }
    }
    ```

## Recommended LSP

For the best experience, we recommend to use the [LuauLSP](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.luau-lsp) extension for Visual Studio Code.

??? Typescript-Types
	You can also use typescript, just be sure you have installed [roblox-ts](https://roblox-ts.com/)

Once you have installed LuauLSP then go to extension settings and search “Definition Files”

![Image](https://cdn.glitch.global/d1a228c9-9cc7-42e7-875e-5a138e0874ab/luauLSP.png){width="100%"}


Click on "Add Item" and then enter this path `packages/UpsideEngine/upside-engine.d.luau`. Then click again on "Add Item" and then enter this path too `packages/UpsideEngine/src/init.d.luau`.


## An important step

To ensure that the Upside Engine works correctly, it is important to initialize the engine on the server, even if you are not using any server-side functionality. This is because some services, such as `NetworkingService`, depend on the server side.

Here is an example of how to initialize upside engine:

```lua
local replicatedStorage = game:GetService("ReplicatedStorage")
local packages = replicatedStorage.packages

local upsideEngine = require(packages.UpsideEngine)
print("Upside Engine version: " .. upsideEngine.Version)
```
___

##### Congratulations you finished the installation of the upside engine framework 🎉🎉
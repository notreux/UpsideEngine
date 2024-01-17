# Installation

!!! warning
    Please be aware that this guide requires the use of Github submodules and Rojo. Before proceeding, make sure that you have initialized a Git repository and are using the Rojo template.

To install the Upside Engine Framework, use the following command to create a new folder named "packages" with the Upside Engine Framework inside:

```git
git submodule add https://github.com/TheHackerPuppy/UpsideEngine packages/UpsideEngine
```

??? working-with-roblox-studio

    
    This tutorial is oriented to external code editors, so there are probably some terms that you do not understand if you only use roblox studio, so here are some clarifications:
        
    - When the tutorial talks about `somefile.client.luau` or `somefile.server.luau`:
        - in the .client case is talking about a <u>local script</u> inside StarterPlayerScripts.
        - in the .server case is talking about a <u>script</u> inside ServerScriptService.
    - When the tutorial doesn't specify if a file is from client side or server side in the file name (example: `somefile.luau`), the tutorial is talking about a module script.
    - When we talk about `src/client` we are are talking about `StarterPlayerScripts`.
    - You may skip the Rojo and LSP sections of this page, but <u>don't skip</u> the ["An important step"](#an-important-step) section.

    ___


    Follow this steps to "install" the package

     - Create a folder in ReplicatedStorage and then name it as "packages"
     - Place the upside engine module in the packages folder
    
    [Download Upside Engine](https://create.roblox.com/marketplace/asset/13243857410){ .md-button .md-basic-button }

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
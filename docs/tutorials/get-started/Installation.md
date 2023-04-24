# Installation

!!! warning
    Please be aware that this guide requires the use of Github submodules and Rojo. Before proceeding, make sure that you have initialized a Git repository and are using the Rojo template.

To install the Upside Engine Framework, use the following command to create a new folder named "packages" with the Upside Engine Framework inside:

```git
git submodules add https://github.com/TheHackerPuppy/UpsideEngine packages/UpsideEngine
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

For the best experience, we recommend to use the [LuauLSP](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.luau-lsp) extension for Visual Studio Code. Additionally, you should download [this file]() which provides all the types of the Upside Engine Framework

??? Typescript-Types
	If you use typescript then download [this file]() instead

Once you have installed LuauLSP and the types file downloaded
	then go to extension settings and search “Definition Files”

![Image](/assets/luauLSP.png){width="100%"}


Once you have installed LuauLSP and downloaded the types file, go to extension settings and search for "Definition Files." Click on "Add Item" and then enter the path to the file. You can use the following path to keep the types up to date: `packages/UpsideEngine/upside-engine.d.luau`


## An important step

To ensure that the Upside Engine functions correctly, it is important to initialize the engine on the server, even if you are not using any server-side functionality. This is because some services, such as `NetworkingService`, depend on the server side.

Here is an example of how to initialize the engine:

```lua
local replicatedStorage = game:GetService("ReplicatedStorage")
local packages = replicatedStorage.packages

local upsideEngine = require(packages.UpsideEngine)
print("Upside Engine version: " .. upsideEngine.Version)
```
___

##### Congratulations you finished the installation of the upside engine framework 🎉🎉
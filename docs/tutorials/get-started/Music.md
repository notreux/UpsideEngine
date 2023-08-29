# Music
 We'll create a new file called `radio.luau` in the `src/client` folder. We are going to add inmersive background music, for this we are going to create a Sprite that represents a radio that is going to have a song gets louder when you get closer to it 

```lua
-- Get necessary services
local replicatedStorage = game:GetService("ReplicatedStorage")
local packages = replicatedStorage.packages

-- Require the upside engine module
local upsideEngine = require(packages.UpsideEngine)
local sceneManager = upsideEngine.GetService("SceneManager")
local scene = sceneManager:FindByName("MyFirstScene")

-- Create the radio
local radio = upsideEngine.new("Sprite")
radio.Instance.ImageRectSize = Vector2.new(37, 64)
radio.TrackCollisions = false
radio:SetScene(scene)
radio:SetSpriteSheet("default", "rbxassetid://12908065852", Vector2.new(14, 1)) -- We pass 14, 1 to say we have 1 row and 14 columns
radio:Play("default")

local radioInstance = radio.Instance
radioInstance.Size = UDim2.fromOffset(128, 128)
radioInstance.Position = UDim2.fromOffset(1540, 865)
radioInstance.ZIndex = 1

-- Create a new sound
local music = upsideEngine.new("Sound")
music.Instance.SoundId = "rbxassetid://1844102827"
music.Instance:Play()
music.Range = 1500
music:SetScene(scene)
music:SetSubject(radio)
```

____

!!! bug
	Remember that you are using a module script, don't forget to return a value at the end of the script!
	```lua
	return {}
	```

You can view and edit the finished project [here](https://www.roblox.com/games/13021482729/Upside-Engine-Getting-Started).

____
##### Great job! You have successfully learned the fundamentals of the Upside Engine framework 🎉🎉<br> The following pages are dedicated to interesting information that you may want to know

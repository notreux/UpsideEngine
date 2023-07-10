# Music
 We'll create a new file called `radio.luau` in the `src/client` folder. We are going to add inmersive background music, for this we are going to create a Sprite that represents a radio that is going to have a song gets louder when you get closer to it 

```lua
-- Get necessary services
local replicatedStorage = game:GetService("ReplicatedStorage")
local packages = replicatedStorage.packages

-- Require the upside engine module
local upsideEngine = require(packages.UpsideEngine)
local sceneManager = upsideEngine:GetService("SceneManager")
local scene = sceneManager:FindByName("MyFirstScene")

-- Create the radio
local radio = upsideEngine:Create("Sprite", scene, Vector2.new(37, 64)) -- we pass 37x64 as resolution
radio:SetSpriteSheet("default", "rbxassetid://12908065852", Vector2.new(1, 14)) -- We pass 1, 14 to say we have 1 row and 14 columns
radio:Play("default")
radio:Set({
	Size = UDim2.fromOffset(128, 128),
	Position = UDim2.fromOffset(1540, 490),
	ZIndex = 3,
})

-- Create a new sound
local music = upsideEngine:Create("Sound", scene)
music.DistanceFading = true
music.Instance:Play()
music:SetSubject(radio)
music:Set({
	SoundId = "rbxassetid://1844102827",
})
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

local upsideEngine = script.Parent.Parent
local classes = upsideEngine.Classes

local character = require(script.Parent.Parent.Classes.Public.Character)
local eventEmitter = require(classes.Internal.EventEmitter)
local crossPlatformService = {}
crossPlatformService.__index = crossPlatformService

function crossPlatformService.new()
	local self = eventEmitter.new()
	self:SetClassName("CrossPlatformService")

	self.DefaultControllersEnabled = true
	self.SideView = true
	self.StickSensibility = 1
	self.Character = character.new()

	self.Configs = {
		Keyboard = {
			W = "Up",
			A = "Left",
			S = "Down",
			D = "Right",

			Up = "Up",
			Left = "Left",
			Down = "Down",
			Right = "Right",
			Space = "Jump",
		},
		Gamepad = {
			ButtonA = "Jump",
			Thumbstick1 = {
				Up = "Up",
				Left = "Left",
				Down = "Down",
				Right = "Right",
			},
		},
		Mobile = {
			JumpButton = "Jump",
			Thumbstick1 = {
				Up = "Up",
				Left = "Left",
				Down = "Down",
				Right = "Right",
			},
		},
	}

	return setmetatable(self, crossPlatformService)
end

--[[={
	@desc Assigns an action to a device key, example:
	```lua
	CrossPlatformService:SetDeviceKey("Keyboard", "Space", "Jump")
	```
	@link void.link
}=]]

function crossPlatformService:SetDeviceKey(device: string, key: string, action: string)
	self.Configs[device][key] = action
end

--[[={
	@desc Sets the entire configuration of a device, example:
	```lua
	CrossPlatformService:SetDeviceConfig("Keyboard", {
		W = "Up",
		A = "Left",
		S = "Down",
		D = "Right",

		Up = "Up",
		Left = "Left",
		Down = "Down",
		Right = "Right",
		Space = "Jump",
	})
	```
	@link void.link
}=]]

function crossPlatformService:SetDeviceConfig(device: string, controls: Dictionary<string, string>)
	self.Configs[device] = controls
end

--[[={
	@desc Sets the player character
	@link void.link
}=]]

function crossPlatformService:SetPlayerCharacter(character: Character)
	self.Character = character
end

--[[={
	@desc This class is used to make the controls functional in any device (Keyboards, Mobiles, Gamepads), this service vinculate actions 
	to specified keys, and also provides a movement system for the player character which can be disabled with the `DefaultControllersEnabled`
	property, here is an example to make our player jumps in every device:
```lua
--  								Device,	    Key, 	Action
CrossPlatformService:SetDeviceKey("Keyboard", "Space", "Jump")
CrossPlatformService:SetDeviceKey("Mobile", "JumpButton", "Jump")
CrossPlatformService:SetDeviceKey("Gamepad", "ButtonA", "Jump")
```


But this is not limited only to movement actions, you can also assign other kind of actions, for example:


```lua
CrossPlatformService:SetDeviceKey("Keyboard", "E", "Collect")
CrossPlatformService:SetDeviceKey("Mobile", "JumpButton", "Collect")
CrossPlatformService:SetDeviceKey("Gamepad", "ButtonA", "Collect")
```


We assigned an action for our devices but how can we detect when an action is triggered? well we can listen to three events
"InputBegin", "InputChange", "InputEnd", example of use:


```lua
-- If the movement belongs to a stick, the second parameter will give the current position of the stick
CrossPlatformService:On("InputBegin", function(action, position)
	local character = CrossPlatformService.Character

	if action == "Jump" then
		character:Jump(150)
	end
end)
```

	@about
		@DefaultControllersEnabled Defines if the default movement system is enabled
		@SideView Defines if the character is going to be seen from the side or from the top
		@Character This is the character which is going to be tracked by the camera
		@StickSensibility This is the sensibility of the sticks in mobile and in game controllers
		@Configs This table stores the default controllers
	@events
		@InputBegin Params -> [UpsideEngineInput](/documentation/datatypes/UpsideEngineInput.html) 
		Fired when one of the keys/sticks in the configuration is pressed/moved
		@InputChange Params -> [UpsideEngineInput](/documentation/datatypes/UpsideEngineInput.html) 
		Fired when the an active input change its value, for example the position of a stick
		@InputEnd Params -> [UpsideEngineInput](/documentation/datatypes/UpsideEngineInput.html) 
		Fired when one of the keys/sticks in the configuration finish to be pressed/moved
}=]]

return setmetatable(crossPlatformService, eventEmitter).new()

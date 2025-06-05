# [Extended from EventEmitter](EventEmitter.md) CrossPlatformService 
This class is used to make the controls functional in any device (Keyboards, Mobiles, Gamepads), this service vinculate actions 
 to specified keys, and also provides a movement system for the player character which can be disabled with the `DefaultControllersEnabled`
 property, here is an example to make our player jumps in every device:
```lua
--  								Device,	    Key, 	Action
CrossPlatformService:SetDeviceKey("Keyboard", "Space", "Up")
CrossPlatformService:SetDeviceKey("Mobile", "JumpButton", "Up")
CrossPlatformService:SetDeviceKey("Gamepad", "ButtonA", "Up")
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
CrossPlatformService:On("InputBegin", function(inputObject)
	local character = CrossPlatformService.Character

	if inputObject.Action == "Up" then
		character:Jump(150)
	end
end)
```

	 
# Properties

## [boolean](boolean.md) DefaultControllersEnabled
Defines if the default movement system is enabled
  
## [boolean](boolean.md) SideView
Defines if the character is going to be seen from the side or from the top
  
## [number](number.md) StickSensibility
This is the sensibility of the sticks in mobile and in game controllers
  
## [Character](Character.md) Character
This is the character which is going to be tracked by the camera
  
## [table](table.md) Configs 
This table stores the default controllers
	 
```lua
{
 	["Keyboard"]: {
 		["W"]: string,
		["A"]: string,
		["S"]: string,
		["D"]: string,
		["Up"]: string,
		["Left"]: string,
		["Down"]: string,
		["Right"]: string,
		["Space"]: string,
		["E"]: string,
	},
	["Gamepad"]: {
 		["ButtonA"]: string,
		["ButtonX"]: string,
		["Thumbstick1"]: {
 			["Up"]: string,
			["Left"]: string,
			["Down"]: string,
			["Right"]: string,
		},
	},
	["Mobile"]: {
 		["JumpButton"]: string,
		["Thumbstick1"]: {
 			["Up"]: string,
			["Left"]: string,
			["Down"]: string,
			["Right"]: string,
		},
	},
}
```


# Methods
## [string](https://create.roblox.com/docs/reference/engine/libraries/string) DetectCurrentDevice() 
 Detects the current device type based on user input capabilities
	
## [string?](https://create.roblox.com/docs/reference/engine/libraries/string) GetTargetActionKey(`action: string`) 
 Returns the current key for a specific action based on the current device (Mobile, Gamepad, or Keyboard)
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetDeviceKey(`device: string, key: string, action: string`) 
 Assigns an action to a device key, example:
	```lua
	CrossPlatformService:SetDeviceKey("Keyboard", "Space", "Up")
	```
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetDeviceConfig(`device: string, controls: Dictionary<string, string>`) 
 Sets the entire configuration of a device, example:
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
		Space = "Up",
	})
	```
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) SetPlayerCharacter(`character: Character`) 
 Sets the player character
	


# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|InputBegin|Params -> [UpsideEngineInput](/documentation/datatypes/UpsideEngineInput.html) <br>  Fired when one of the keys/sticks in the configuration is pressed/moved<br>  |
|InputChange|Params -> [UpsideEngineInput](/documentation/datatypes/UpsideEngineInput.html) <br>  Fired when the an active input change its value, for example the position of a stick<br>  |
|InputEnd|Params -> [UpsideEngineInput](/documentation/datatypes/UpsideEngineInput.html) <br>  Fired when one of the keys/sticks in the configuration finish to be pressed/moved<br>|




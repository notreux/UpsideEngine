# Character
!!! info 
	 This object was [Extended from Sprite](Sprite.md)
This class is used for the player character and for npcs
	 
 
# Properties

## [readonly](readonly.md) [number](number.md) <u>Health</u> 
The amount of health of the character
		
___
## [rules](rules.md) [number](number.md) <u>MaxHealth</u> 
The maximum amount of health of the character 
		
___
## [rules](rules.md) [number](number.md) <u>WalkSpeed</u> 
The walk speed of the character
		
___
## [rules](rules.md) [number](number.md) <u>JumpPower</u> 
The jump power of the character

___


# Methods

### [void](https://create.roblox.com/docs/scripting/luau/nil) UpdateHealth`(Health: number)` 
Updates the amount of health of the character 
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Jump`(jumpPower: number?)` 
The character jumps with the provided jump power, if none is provided it will use the JumpPower property as value 
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) MoveTo`(target: Vector2)` 
The character walks directly to the provided position
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




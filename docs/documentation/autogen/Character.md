# [Extended from Sprite](Sprite.md) Character 
This class is used for the player character and for npcs
	 
# Properties

## [number](number.md) Health
The amount of health of the character
		
## [number](number.md) MaxHealth
The maximum amount of health of the character 
		
## [number](number.md) WalkSpeed
The walk speed of the character
		
## [number](number.md) JumpPower
The jump power of the character
		
## [boolean](boolean.md) IsJumping
Set to true when the character is jumping



# Methods

## [void](https://create.roblox.com/docs/scripting/luau/nil) UpdateHealth(`Health: number`) 
 Updates the amount of health of the character 
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Jump(`jumpPower: number?`) 
 The character jumps with the provided jump power, if none is provided it will use the JumpPower property as value 
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) MoveTo(`target: Vector2`) 
 The character walks directly to the provided position
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




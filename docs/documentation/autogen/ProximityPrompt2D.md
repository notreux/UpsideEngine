# [Extended from Sprite](Sprite.md) ProximityPrompt2D 
The proximity prompt is a UI element that will show a prompt when the player is close to it, this is used to interact with objects in the game, it will show a label and a hitbox that will be used to detect when the player is close to it
	 
# Properties

## [number](number.md) Range
The range of the prompt, this will be used to detect when the prompt should be shown
        
## [string](string.md) ActionName
The action name of the prompt, this will be used to detect when the 
        prompt is triggered, if you change the default action name you should change or 
        add a new action in the CrossPlatformService, 'Interact' by default
  
## [boolean](boolean.md) Enabled
If the prompt is enabled or not, if it is not enabled the prompt will not be shown
  
## [boolean](boolean.md) IsClosest
True if the proximity prompt is the closest one to the player
  
## [boolean](boolean.md) InRange
True if the proximity prompt is visible on the player's screen. Useful for detecting when the prompt is within interaction range
        
## [boolean](boolean.md) ShowIfClosest
Determines whether this proximity prompt should only be shown when it is the closest one to the player.
  If set to true, the prompt will only appear if it is the nearest among all prompts within interaction range.
  If set to false, the prompt will be shown as long as it is within range, regardless of other nearby prompts.
  The property is enabled by default
	
## [number](number.md) FadeDuration
The duration of the fade in and out of the prompt, this will be used to make the prompt appear and disappear smoothly
  
## [Instance](Instance.md) Label
The text label of the prompt, this will be shown when the prompt is active
        
## [Instance](Instance.md) HitboxButton
The button that will be used to trigger the proximity prompt on mobile devices
  
## [number](number.md) SecondsPerFrame

## [string](string.md) Name

## [table](table.md) LabelPositions 
A table containing the positions(as UDim2) of the label, this will be used to adjust the text to the proximity prompt sprites, position 0 will be the position on the first frame, position 1 will be the position on the second frame, etc.
   
```lua
{ }
```


# Methods
There is no methods for this class

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|Triggered|Fired when the proximity prompt is triggered. This occurs when the player begins interacting with the prompt.<br>  |
|TriggerEnded|Fired when the proximity prompt interaction ends. This occurs when the player releases the interaction.<br>|




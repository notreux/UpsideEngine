# [Extended from BaseObject](BaseObject.md) ReactiveLabel 
UI element that renders text with a typewriter effect, text animations and supports roblox rich text. 
	 
# Properties

## [Enum](Enum.md) Font
The font used for displaying text.
  
## [number](number.md) FontSize
The font size of the text.
  
## [string](string.md) Text
The text content to be rendered.
  
## [number](number.md) TextTransparency

## [Color3](Color3.md) TextColor3

## [boolean](boolean.md) TextScaled
Determines if the text scales automatically.
  
## [boolean](boolean.md) Animated
If true, renders text progressively like a typewriter.
  
## [Color3](Color3.md) TextStrokeColor3

## [number](number.md) TextStrokeTransparency
Transparency of the text stroke.
  
## [number](number.md) TextStrokeThickness
Thickness of the text stroke.
  
## [number](number.md) CharactersPerSecond
 The number of characters rendered per second.
  
## [number](number.md) TypingSoundVolume
The volume of the typing sound.
  
## [boolean](boolean.md) StopSoundOnFinish
If true, stops the typing sound once rendering is complete.
  
## [table](table.md) PauseDelays 
A table defining additional pause durations after certain characters (e.g., comma, period).
  -- Example of PauseDelays usage:
  {
  	[","] = 0.25, -- pause 0.25 seconds after a comma
  	["."] = 0.5,  -- pause 0.5 seconds after a period
  	["?"] = 0.5,  -- pause 0.5 seconds after a question mark
  }
 
```lua
{
 	[","]: number,
	["."]: number,
	["?"]: number,
}
```
## [UDim2](UDim2.md) Size

## [number](number.md) BackgroundTransparency



# Methods
## [void](https://create.roblox.com/docs/scripting/luau/nil) Render() 
 Renders the label text with a typewriter effect, yielding during animations.
	


# Events
There is no events for this class



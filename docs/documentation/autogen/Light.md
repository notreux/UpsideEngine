# Light
!!! info 
	 This object was [Extended from PhysicalObject](PhysicalObject.md)
This class is used to illuminate areas in the darkness
	 
 
# Properties

## [readonly](readonly.md) [boolean](boolean.md) <u>TrackCollisions</u> 
Its a property of PhysicalObject, in this class is marked as readonly and is set false to optimizate
		
___
## [rules](rules.md) [Color3](Color3.md) <u>Color</u> 

___
## [rules](rules.md) [number](number.md) <u>Range</u> 
Is the range of the light
		
___
## [rules](rules.md) [number](number.md) <u>Brightness</u> 
Is the brightness of the light
		
___
## [rules](rules.md) [boolean](boolean.md) <u>Track</u> 
If this property is set to true the light is tracked, so it appears on the screen, if it is disabled and it was tracked at some point,
		it will appear on the screen but if at any time another light enters in the range of this light, this light will start to modify the shape of the initial light, that's because we can say that when we disable the
		the shape of the initial light, that is because it could be said that when we disable the Track property what remains on the screen is the trace of the light.

___


# Methods

### [Light](Light.md) Constructor`(scene: Scene)` 

___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




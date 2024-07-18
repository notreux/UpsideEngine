# [Extended from BaseClass](BaseClass.md) Shader 
!!! warning 
  	Shaders are very cpu-intensive, so it is not recommended to use them with high resolution images
  	and not to use too many shaders.

  	If you need to scale an image, do it in the studio, instead of doing it in the editing program, 
  	this will lighten a lot the work for the cpu.	

  _____
  This class is used to modify how an object is renderized
	 
# Properties

## [boolean](boolean.md) Enabled
This property determines if the shader is enabled
        
## [number](number.md) Precision
Sometimes, modifying the position of pixels in an image can create gaps.
  Upside Engine automatically fills these gaps, but this can occasionally 
  lead to unwanted effects. Therefore, adjust this property according to your needs, 
  the value of this property ranges between 0 and 1.

## [string](string.md) Path
This property stores the shader path
        


# Methods

## [void](void.md) SetSource(`file: ModuleScript`) 
 Sets the module script which is going to be used as shader source
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




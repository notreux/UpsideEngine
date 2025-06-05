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
  
## [boolean](boolean.md) PreloadSprites
When this property is marked as true every animation of a sprite will be preloaded, 
  if not the animations will be loaded dynamically
  
## [boolean](boolean.md) MirrorEnabled
This property determines if the shader will use the mirror source or not, false by default
        
## [ImageLabel](ImageLabel.md) MirrorSource
The current mirror source, nil by default ImageLabel if an object is set using SetMirrorSource()
  
## [number](number.md) Precision
Sometimes, modifying the position of pixels in an image can create gaps.
  Upside Engine automatically fills these gaps, but this can occasionally 
  lead to unwanted effects. Therefore, adjust this property according to your needs, 
  the value of this property ranges between 0 and 1.

## [string](string.md) Path
This property stores the shader path
        


# Methods
## [void](void.md) SetMirrorSource(`object: StaticObject`) 
 Sets the mirror source object for rendering the shader. When a mirror source is specified, 
 the shader uses its `ImageRectOffset` and `ImageRectSize` to render. All objects to which this shader
 is applied will display the exact same result, mirroring the appearance of the source object. 
 If no mirror source is set, each object will be rendered independently, 
 which may lead to decreased performance.
	
## [void](void.md) SetSource(`file: ModuleScript`) 
 Sets the module script which is going to be used as shader source
	


# Events
There is no events for this class



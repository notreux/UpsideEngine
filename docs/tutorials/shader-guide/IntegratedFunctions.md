# Integrated Functions
On the previous page, you saw the variables that are automatically injected by Upside Engine. On this page, you will explore the functions that Upside Engine injects into your shading function, which can help you create interesting effects.

___

# Shader Functions
## [r, g, b, a](https://create.roblox.com/docs/luau/numbers) texture(`source: ImageLabel`, `position: Vector2`)
- source :octicons-arrow-right-24: The image from which the specified pixel is read.

- position :octicons-arrow-right-24: It's the position of the pixel to read.

- returns :octicons-arrow-right-24: Returns the RGBA values of a pixel at a specified position and returns them as numbers.


## [x, y](https://create.roblox.com/docs/luau/numbers) rotate(`centre: Vector2`, `position: Vector2`, `degrees: number`)

- centre :octicons-arrow-right-24: The position that will be used as the center when rotating the other pixels.

- position :octicons-arrow-right-24: The position of the pixel to be rotated.

- degrees :octicons-arrow-right-24: The number of degrees you want to rotate that pixel.

- returns :octicons-arrow-right-24: Returns the rotated position of the pixel as numbers.

## Example
Let's apply the image from a camera to our water texture. Initially, the camera image will appear in the top left corner, but we can adjust its position to a more suitable location. To do this, we will modify its position by subtracting an offset, which is a Vector2 that allows us to move the camera image across the texture.

```lua
local source = Instance.new("ImageLabel")
source.Image = "http://www.roblox.com/asset/?id=16157374575"

return function()
	local offset = Vector2.new(60, 80)
    local position = Vector2.new(x, y)
	local r, g, b, a = texture(source, position - offset)
	
	red += r
	green += g
	blue += b
	opacity += a
end

```

As you can see, the camera image appears in the water:

![](../../assets/texture.png)

But it has a bluish tint. This happens because we are blending the water's pixel colors with the camera's. If we want to display only the camera's pixels, we can do the following:
```lua
local source = Instance.new("ImageLabel")
source.Image = "rbxassetid://cameraId"

return function()
	local offset = Vector2.new(60, 80)
    local position = Vector2.new(x, y)
	local r, g, b, a = texture(source, position - offset)
	
	if a == 0 then
		return
	end	

	red = r
	green = g
	blue = b
	opacity = a
end
```
As you can see, now the camera looks normal:

![](../../assets/normaltexture.png)


Perfect, now let's use the `rotate` function. With this function, we'll rotate the water image around itself. Since the image resolution is 128x128, we'll use the position 64, 64 as the center. Additionally, we'll use `clock` to make our image rotate continuously, multiplying it by the desired rotational speed.

```lua
return function()
	local clock = os.clock()	
    local speed = 25
	
    local centre = Vector2.new(64, 64)
    local position = Vector2.new(x, y)

	x, y = rotate(centre, position, clock * speed)
end
```

final result:
<video width="700" controls>
  <source src="../../assets/rotation.mp4" type="video/mp4">
</video>
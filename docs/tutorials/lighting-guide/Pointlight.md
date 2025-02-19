## Pointlight

Pointlights simulate an omnidirectional light source, emitting light evenly in every direction. This makes them ideal for representing objects like lamps, torches, or any diffuse light source in your game. In this section, we create a pointlight, configure its properties, and integrate it into our scene.

Below is the sample code to set up a pointlight:

```lua
local pointlight = UpsideEngine.new("Light") -- Create a new Light object using UpsideEngine
pointlight:SetScene(scene)                   -- Attach the pointlight to the current scene
pointlight.Shape = "pointlight"              -- Set the light's shape to "pointlight", making it omnidirectional
pointlight.Range = 800                       -- Define the light's effective radius (how far the light reaches)
pointlight.Color = Color3.fromRGB(255, 0, 0) -- Set the light's color to red using RGB values
pointlight.Inverted = false                  -- Determine the rendering style: false for a standard pointlight
                                             -- true would create a halo effect around the light
```

## Making the Pointlight Follow the Mouse

To create an interactive effect, you can update the pointlight's position so that it follows the mouse cursor.
Below is the sample code to achieve this behavior for the pointlight:

```lua
RunService.Heartbeat:Connect(function(dt)
    -- Update the pointlight's position to follow the mouse movement
    pointlight.Instance.Position = UDim2.fromOffset(mouse.X, mouse.Y)
end)
```
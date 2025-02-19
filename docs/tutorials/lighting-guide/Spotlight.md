# Spotlight

Spotlights create a focused beam of light. In this section, we create a spotlight and add interactivity by making it follow the mouse cursor and rotate over time.

```lua
local spotlight = UpsideEngine.new("Light")  
spotlight:SetScene(scene)  
spotlight.Shape = "spotlight"               -- Set the light's shape to "spotlight" to simulate
                                            -- a directional beam.
spotlight.Range = 500  
spotlight.Angle = 100                       -- Set the angle (in degrees) of the spotlight's beam
                                            -- smaller angle results in a narrower, more focused beam.
spotlight.Color = Color3.fromRGB(0, 0, 255)  

RunService.Heartbeat:Connect(function(dt)  
    spotlight.Instance.Position = UDim2.fromOffset(mouse.X, mouse.Y)  
    spotlight.Rotation = spotlight.Rotation + 100 * dt -- Rotate the spotlight continuously  
end)  
```

---

With these three sections, You have learned how the UpsideEngine lighting system works. Experiment with the properties and behavior of the lights to best suit your game's esthetic and interactive needs.

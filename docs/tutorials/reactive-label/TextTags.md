Upside Engine allows you to create custom text effects using the `TextTag` object. This makes it possible to extend the functionality of `ReactiveLabel` with your own unique animations and formatting behaviors.

In this guide, you'll learn how to define a custom tag called `wave` that animates characters in a vertical sinusoidal motion.

---

### Step-by-Step: Creating the `wave` TextTag

```lua
local frameRate = 60
local defaultAmplitude = 5

local wave = upsideEngine.new("TextTag")
wave:SetTagName("wave")

wave:SetRenderFunction(function(label, i, args)
    local amplitude = args.intensity or defaultAmplitude
    local duration = args.duration or 1
    local steps = math.max(1, math.floor(duration * frameRate))

    for step = 0, steps do
        local phase = (2 * math.pi) * (step / steps) + (i or 0)
        local offsetY = amplitude * math.sin(phase)
        label.Position = UDim2.new(0, 0, 0, offsetY)
        task.wait(duration / steps)
    end

    label.Position = UDim2.new(0, 0, 0, 0)
end)
```

#### Key Elements:

* `SetTagName("wave")` defines the tag name used inside the text.
* `SetRenderFunction(...)` registers the function that will animate each character individually.
* `i` refers to the character index in the string.
* `args` allows you to pass custom parameters from the tag, like `intensity` and `duration`.

---

### Using the Custom Tag in ReactiveLabel

Once you've defined your `wave` tag, you can use it directly inside the text string assigned to `ReactiveLabel.Text`:

```lua
reactiveLabel.Text = [[
    <wave intensity=8 duration=1.2><font color="#00ccff">Wavy text is cool!</font></wave>
]]

reactiveLabel:Render()
```

This will animate each character with a vertical wave effect using the parameters provided.

---

### Final Result Example

```lua
local reactiveLabel = upsideEngine.new("ReactiveLabel")
reactiveLabel.Instance.Parent = dialogBox
reactiveLabel.Instance.Size = UDim2.fromScale(1, 1)
reactiveLabel.Font = Enum.Font.Arcade
reactiveLabel.StopSoundOnFinish = false

reactiveLabel.Text = [[
    <wave intensity=6 duration=1><font color="#ff4500"> Hello!! </font></wave>
    I'm feeling good today,
    <wave><gradient startColor="#ff4500" endColor="#ff9933"> how are you? </gradient></wave>
]]

reactiveLabel:Render()
```

In this example, the `wave` tag is combined with color and gradient tags to produce a vibrant animated dialog effect.

> ✅ You can define as many custom `TextTags` as you'd like—experiment with different animations and bring your text to life!

---

### Tips

* Keep animations lightweight for performance.
* Combine tags creatively (e.g., `<shake><font>text</font></shake>`).
* Always test on multiple screen resolutions for best results.

---

##### You're now ready to build your own animated text effects using `TextTag`!

The `ReactiveLabel` is a powerful component of Upside Engine that allows developers to display rich, animated text in their 2D game UIs. It supports custom effects, such as wave, shake, gradient, and more, all parsed directly from the text string using tags.

This component is especially useful for dialog systems or any dynamic text-based UI where visual expression is key.

---

### How it works

`ReactiveLabel` is created using this constructor:

```lua
local reactiveLabel = upsideEngine.new("ReactiveLabel")
```

Once created, it exposes an `Instance` property, which is a `TextLabel` object that can be customized using standard Roblox properties such as `Font`, `Size`, `TextColor3`, and more.

The core functionality is triggered by calling the `:Render()` method after assigning the desired text:

```lua
reactiveLabel.Text = "<wave>Hello World!</wave>"
reactiveLabel:Render()
```

This will animate the text based on the tags used inside the string.

---

### Available Tags

ReactiveLabel supports several built-in animation and formatting tags (including rich text tags):

* `<wave>` \:octicons-arrow-right-24: Animates the text in a wave pattern.
* `<shake>` \:octicons-arrow-right-24: Shakes the text with configurable intensity and duration.
* `<gradient>` \:octicons-arrow-right-24: Applies a color gradient to the text.
* `<angry>` \:octicons-arrow-right-24: A predefined shake-and-color effect expressing anger.

All of these tags can be combined to create complex animated text blocks.

---

### Key Features

Some of the most important properties of `ReactiveLabel` include:

- **Text** : `string`  
  The text content to display, including formatting tags like `<wave>`, `<shake>`, etc.

- **Font** : `Enum.Font`  
  Sets the typeface used for the text (default: `Arial`).

- **CharactersPerSecond** : `number`  
  Controls the speed of the typing animation (default: `20`).

- **TypingSoundId** : `string`  
  Sound ID played while characters are being animated (default: `rbxassetid://92143495194538`).

- **StopSoundOnFinish** : `boolean`  
  Whether the typing sound stops when the animation ends (default: `true`).

- **PauseDelays** : `table`  
  Defines delays after punctuation marks, e.g., `{ [","] = 0.25, ["."] = 0.5 }`.

- **Animated** : `boolean`  
  Enables or disables all animation behavior (default: `true`).

> 🔍 For a full list of configurable properties, check the [API Reference](../../documentation/autogen/ReactiveLabel.md).

---

### Example Usage

```lua
local reactiveLabel = upsideEngine.new("ReactiveLabel")
reactiveLabel.Instance.Parent = someGuiElement
reactiveLabel.Instance.Size = UDim2.fromScale(1, 1)
reactiveLabel.Font = Enum.Font.Arcade
reactiveLabel.StopSoundOnFinish = false

reactiveLabel.Text = [[
    <wave intensity=6 duration=1>
        <font color="#ff4500"> Hello!! </font>
    </wave>
    I'm feeling good today,
    <wave>
        <gradient startColor="#ff4500" endColor="#ff9933"> how are you? </gradient>
    </wave>
]]

reactiveLabel:Render()
```

This code snippet renders animated, color-rich dialog text inside the UI. The tags are interpreted at runtime, and the animation is handled automatically by the engine.

---

### Integration Example (Dialog System)
ReactiveLabel is perfect for switching characters and lines dynamically:

```lua
for _, data in dialog do
    nameLabel.Text = data.name
    reactiveLabel.Text = data.text
    reactiveLabel:Render()
    task.wait(1)
end
```

This loop updates the name and dialog content dynamically, allowing for animated conversations between characters.

---

### Final Notes
- `:Render()` **must** be called after setting the `Text` property in order to display animations.
- Be mindful of performance when rendering very large or highly animated blocks of text.
- Supports rich text formatting and animations using custom tags.
- Text playback speed and behavior can be fine-tuned via properties like `CharactersPerSecond` and `PauseDelays`.
- Sound effects for typing can be customized with `TypingSoundId` and `TypingSoundVolume`.
- Additional customization options are available in the [API Reference](../../documentation/autogen/ReactiveLabel.md).

---

##### You're ready to bring your game text to life with ReactiveLabel!

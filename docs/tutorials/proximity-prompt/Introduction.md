### ProximityPrompt2D

The `ProximityPrompt2D` is a UI component in the Upside Engine that allows players to interact with in-game objects when they're nearby, using a customizable 2D interface.

---

### How it works

To create a `ProximityPrompt2D`, you instantiate it using the Upside Engine:

```lua
local ProximityPrompt = UpsideEngine.new("ProximityPrompt2D")
```

Once created, you must define its visual behavior and connection to your scene:

```lua
ProximityPrompt:SetScene(Scene)
ProximityPrompt.Instance.Position = UDim2.new(0, 0, 0, -250)
ProximityPrompt.Range = 500
```

To attach the prompt to a specific object (so it follows its position), use:

```lua
ProximityPrompt:Attach(car)
```

To detach it:

```lua
ProximityPrompt:Detach()
```

---

### Key Properties

* **Range : `number`**
  Maximum distance at which the prompt becomes visible (default: `100`).

* **ActionName : `string`**
  Identifier used to bind the prompt to a specific input key or control scheme. Defaults to `"Interact"`.

  To configure which key triggers it, use:

  ```lua
  CrossPlatformService:SetDeviceKey("Keyboard", "T", "Interact")
  ```

* **Enabled : `boolean`**
  Enables or disables the prompt entirely.

* **ShowIfClosest : `boolean`**
  When true (default), the prompt only shows if it's the closest one to the player.

* **FadeDuration : `number`**
  Time (in seconds) for the prompt to fade in or out when entering or leaving range.

* **LabelPositions : `UDim2[]`**
  An array of `UDim2` values defining the position of the text label for each frame of the idle spritesheet animation. The label adjusts its position depending on the current frame.

* **IsClosest : `boolean`** *(informative)*
  Read-only value set by the system to indicate whether this is the closest prompt.

* **InRange : `boolean`** *(informative)*
  Read-only value set by the system to indicate if the player is within range.

---

### Customizing the Visuals

You can override the default idle animation by changing the spritesheet:

```lua
ProximityPrompt:SetSpriteSheet("idle", url, Vector2.new(framesX, framesY))
```

Make sure the number of elements in `LabelPositions` matches the number of frames defined in the spritesheet.

---

### Example Usage

```lua
local ProximityPrompt = UpsideEngine.new("ProximityPrompt2D")
ProximityPrompt.Instance.Position = UDim2.new(0, 0, 0, -250)
ProximityPrompt:SetScene(Scene)
ProximityPrompt.Range = 500
ProximityPrompt.ActionName = "OpenShop"

CrossPlatformService:SetDeviceKey("Keyboard", "F", "OpenShop")
```

This configuration creates a prompt that becomes visible when the player is within 500 pixels and will trigger when the "F" key is pressed.

---

### Use Cases

* Opening a door when the player gets close
* Talking to an NPC
* Interacting with a vendor, terminal, or sign

---

### Final Notes

* You should not modify `IsClosest` or `InRange`; they are managed internally.
* Always call `SetScene` to ensure the prompt is correctly added to the game scene.


---

##### With ProximityPrompt2D, bringing interactive UI to life in 2D games has never been easier!

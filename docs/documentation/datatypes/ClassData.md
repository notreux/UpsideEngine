# UpsideEngineInput
A ClassData represents the data needed to extend a class 

<br>
# Properties

```lua
{
	name -> string,
	constructor -> Dictionary<string, () -> ()>,
	methods -> Dictionary<string, () -> ()>,
	private -> Dictionary<string, any>,
	readonly -> Dictionary<string, any>,
	rules -> Dictionary<string, any>,
}
```
# Connection
!!! info 
	 This object was [Extended from BaseClass](BaseClass.md)
This class is used in the event emitter class, its used to manage a listener
	 
 
# Properties

## [readonly](readonly.md) [boolean](boolean.md) <u>Active</u> 
Defines if the connection is active or not

___


# Methods

### [Connection](Connection.md) Constructor`(eventId: number, event: Dictionary<string, table>)` 

___
### [thread?](https://create.roblox.com/docs/reference/engine/libraries/coroutine) Wait`(seconds: number?)` 
Wait until the event gets fired, if seconds were specified, once the specified seconds have elapsed, it will stop waiting
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Disconnect`()` 
Deletes the connection and the listener
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




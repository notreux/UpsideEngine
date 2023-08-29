# [Extended from BaseClass](BaseClass.md) Connection 
This class is used in the event emitter class, its used to manage a listener
	 
# Properties

## [boolean](boolean.md) Active
Defines if the connection is active or not

## [number](number.md) EventId

## [table](table.md) Event 
 
	```lua 
	{ 	} 
	```


# Methods

## [Connection](Connection.md) Constructor(eventId: number, event: table) 
 
## [thread?](https://create.roblox.com/docs/reference/engine/libraries/coroutine) Wait(seconds: number?) 
 Wait until the event gets fired, if seconds were specified, once the specified seconds have elapsed, it will stop waiting
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Disconnect() 
 Deletes the connection and the listener
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|




# [Extended from EventEmitter](EventEmitter.md) Request 
This class is used for the client replication
	 
# Properties

## [table](table.md) Content 
The content of the request
		 
```lua
{ }
```
## [string](string.md) ClientId
The UserId of the client which sent the request if exists 
	


# Methods

## [void](https://create.roblox.com/docs/scripting/luau/nil) Send(`content: Dictionary<string, any>`) 
 Sends the request to the server
	
## [void](https://create.roblox.com/docs/scripting/luau/nil) Approve() 
 The request is approved and its replicated all the clients
	
## [void](BaseObject.md) Accept() 
 Accepts the request and builds the object to be replicated
	
## [void](https://create.roblox.com/docs/reference/engine/classes/Player) GetClient() 
 Returns the player which sent the request
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|Build|Params -> [BaseObject](BaseObject.md)<br>Fired when a request is accepted and the object to be replicated is being built<br>|




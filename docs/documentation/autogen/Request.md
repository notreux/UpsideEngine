# Request
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class is used for the client replication
	 
 
# Properties

## [readonly](readonly.md) [table](table.md) <u>Content</u> 
The content of the request
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [readonly](readonly.md) [number](number.md) <u>ClientId</u> 
The UserId of the client which sent the request if exists 
	
___


# Methods

### [Request](Request.md) Constructor`(clientId: number, content: Dictionary<string, any>)` 

___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Send`(content: Dictionary<string, any>)` 
Sends the request to the server
	
___
### [void](https://create.roblox.com/docs/scripting/luau/nil) Approve`(clients: table)` 
The request is approved and its replicated to the specified clients, if none is specified it will be replicated to all the clients except to the client who sent the request
	
___
### [BaseObject](BaseObject.md) Accept`(...any)` 
Accepts the request and builds the object to be replicated
	
___
### [void](https://create.roblox.com/docs/reference/engine/classes/Player) GetClient`()` 
Returns the player which sent the request
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|Build|Params -> [BaseObject](BaseObject.md)<br>Fired when a request is accepted and the object to be replicated is being built<br>|




# NetworkingService
!!! info 
	 This object was [Extended from EventEmitter](EventEmitter.md)
This class is to replicate objects to other clients, for example the player character
	 
 
# Properties

## [readonly](readonly.md) [table](table.md) <u>Players</u> 
A dictionary with the replicated objects by the clients
		 
???+ Content 
	```lua 
	{ 	} 
	```
## [rules](rules.md) [boolean](boolean.md) <u>DestroyObjectsOnLeave</u> 
Defines if the replicated objects by other clients should be destroyed when they leaves
	
___


# Methods

### [void](void.md) Replicate`(object: BaseObject)` 
Replicates an object to other clients

___
### [(Connection, Connection)](Connection.md) ReplicateOnChange`(object: BaseObject)` 
Replicates an object and each change on it, and returns the connections that detect each change of the object
	
___

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|ReplicationRequest|Params -> [Request](Request.md) <br>Fired when a request is received by the client<br>|




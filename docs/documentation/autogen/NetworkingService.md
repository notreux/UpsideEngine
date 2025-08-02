# [Extended from EventEmitter](EventEmitter.md) NetworkingService 
This class is used to replicate objects to other clients, for example the player character
	 
# Properties

## [number](number.md) ReplicationPerSecond
Specifies the number of replication requests per second to send when using ReplicateOnChange
  
## [boolean](boolean.md) DestroyObjectsOnLeave
If true, destroys replicated objects from other clients when they leave
  
## [table](table.md) ReplicationTarget 
Table of objects from other clients currently targeted for replication
   
```lua
{ }
```
## [table](table.md) PlayersData 
Dictionary containing the replicated objects for each client (keyed by UserId)
   
```lua
{ }
```
## [table](table.md) Cache 
 
```lua
{ }
```


# Methods
## [void](void.md) Replicate(`object: BaseObject`) 
 Replicates an object to other clients

## [RBXScriptConnection](Connection.md	) ReplicateOnChange(`object: BaseObject`) 
 Replicates an object and each change on it, and returns the connections that detect each change of the object
	


# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|ReplicationRequest|Params -> [Request](Request.md) <br>  Fired when a request is received by the client<br>|




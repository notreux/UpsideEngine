export type NetworkingService = {
Players: 	{ 	},
DestroyObjectsOnLeave: boolean
Replicate(self: NetworkingService, object: BaseObject): null
ReplicateOnChange(self: NetworkingService, object: BaseObject): (Connection, Connection)
}


module.exports = {}
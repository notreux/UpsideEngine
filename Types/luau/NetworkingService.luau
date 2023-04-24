export type NetworkingService = EventEmitter & {
Players: 	{ 	},
DestroyObjectsOnLeave: boolean,
Replicate: (self: NetworkingService, object: BaseObject) -> nil,
ReplicateOnChange: (self: NetworkingService, object: BaseObject) -> (Connection, Connection),
}


return {}
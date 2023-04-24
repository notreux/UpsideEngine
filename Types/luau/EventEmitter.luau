export type EventEmitter = BaseClass & {
EventsStorage: 	{ 	},
On: (self: EventEmitter, name: string, callback: () -> ()) -> Connection,
Fire: (self: EventEmitter, name: string, ...any) -> nil,
}


return {}
export type EventEmitter = {
EventsStorage: 	{ 	},
On(self: EventEmitter, name: string, callback: () -> ()): Connection
Fire(self: EventEmitter, name: string, ...any): null
}


module.exports = {}
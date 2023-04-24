export type BaseObject = EventEmitter & {
Instance: Instance,
Scene: string,
InstanceType: string,
Tags: 	{ 	},
new: (self: BaseObject, parent: Scene) -> BaseObject,
Set: (self: BaseObject, properties: Dictionary<string, any>) -> nil,
AddTag: (self: BaseObject, tag: string) -> nil,
HasTag: (self: BaseObject, tag: string) -> boolean,
RemoveTag: (self: BaseObject, tag: string) -> nil,
}


return {}
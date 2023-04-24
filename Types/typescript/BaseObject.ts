export type BaseObject = {
Instance: Instance
Scene: string
InstanceType: string
Tags: 	{ 	},
new(self: BaseObject, parent: Scene): BaseObject
Set(self: BaseObject, properties: Dictionary<string, any>): null
AddTag(self: BaseObject, tag: string): null
HasTag(self: BaseObject, tag: string): boolean
RemoveTag(self: BaseObject, tag: string): null
}


module.exports = {}
export type Environment = BaseObject & {
Content: 	{ 	},
Count: number,
InstanceType: string,
new: (self: Environment) -> Environment,
Get: (self: Environment, index: string) -> any,
AddOne: (self: Environment, value: any, index: string) -> nil,
RemoveOne: (self: Environment, index: string) -> nil,
HasOne: (self: Environment, index: string) -> boolean,
Has: (self: Environment, objects: Array<string>) -> (boolean, Dictionary<string, boolean>),
Add: (self: Environment, objects: Dictionary<string, any>) -> nil,
Remove: (self: Environment, objects: Array<string>) -> nil,
Update: (self: Environment, objects: Dictionary<string, any>) -> nil,
FindByName: (self: Environment, name: string) -> any,
SetProperty: (self: Environment, property: string, value: any) -> nil,
Run: (self: Environment, method: string, ...any) -> nil,
}


return {}
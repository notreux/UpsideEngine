export type Environment = {
Content: 	{ 	},
Count: number
InstanceType: string
new(self: Environment): Environment
Get(self: Environment, index: string): any
AddOne(self: Environment, value: any, index: string): null
RemoveOne(self: Environment, index: string): null
HasOne(self: Environment, index: string): boolean
Has(self: Environment, objects: Array<string>): (boolean, Dictionary<string, boolean>)
Add(self: Environment, objects: Dictionary<string, any>): null
Remove(self: Environment, objects: Array<string>): null
Update(self: Environment, objects: Dictionary<string, any>): null
FindByName(self: Environment, name: string): any
SetProperty(self: Environment, property: string, value: any): null
Run(self: Environment, method: string, ...any): null
}


module.exports = {}
export type Request = {
Content: 	{ 	},
ClientId: number
new(self: Request, clientId: number, content: Dictionary<string, any>): Request
Send(self: Request, content: Dictionary<string, any>): null
Approve(self: Request, clients: table): null
Accept(self: Request, ...any): BaseObject
GetClient(self: Request): null
}


module.exports = {}
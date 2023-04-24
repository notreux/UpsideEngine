export type Request = EventEmitter & {
Content: 	{ 	},
ClientId: number,
new: (self: Request, clientId: number, content: Dictionary<string, any>) -> Request,
Send: (self: Request, content: Dictionary<string, any>) -> nil,
Approve: (self: Request, clients: table) -> nil,
Accept: (self: Request, ...any) -> BaseObject,
GetClient: (self: Request) -> nil,
}


return {}
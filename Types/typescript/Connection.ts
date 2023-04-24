export type Connection = {
Active: boolean
new(self: Connection, eventId: number, event: Dictionary<string, table>): Connection
Wait(self: Connection, seconds: number?): thread?
Disconnect(self: Connection): null
}


module.exports = {}
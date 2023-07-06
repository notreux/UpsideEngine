local baseClass = require(script.Parent.BaseClass)
local methods = {}
local constructor = {}

local function unyield(seconds, running)
	task.wait(seconds)
	coroutine.resume(running)
end

--[[={
	@link Connection.md
}=]]

function constructor:Connection(data: ConnectionParams)
	addReadonly({ EventId = data.EventId, Event = data.Event })
end

--[[={
	@desc Wait until the event gets fired, if seconds were specified, once the specified seconds have elapsed, it will stop waiting
	@link thread.link
}=]]

function methods:Wait(seconds: number?): thread?
	local running = coroutine.running()
	if not self.Active then
		return
	end

	if seconds then
		task.defer(unyield, seconds, running)
	end

	table.insert(self.Event.Threads, running)
	return coroutine.yield()
end

--[[={
	@desc Deletes the connection and the listener
	@link void.link
}=]]

function methods:Disconnect()
	self.Active = false
	self.Event.Functions[self.EventId] = nil
	self:Destroy()
end

--[[={
	@desc This class is used in the event emitter class, its used to manage a listener
	@about
		@Active Defines if the connection is active or not
}=]]

return baseClass:Extend(script.Name, {
	constructor = constructor,
	methods = methods,
	readonly = {
		Active = true,
	},
})

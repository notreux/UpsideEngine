local baseClass = require(script.Parent.BaseClass)
local connection = require(script.Parent.Connection)

local testService = game:GetService("TestService")
local methods = {}

local function getEvent(events, name)
	if not events[name] then
		events[name] = {
			Functions = {},
			Threads = {},
		}
	end

	return events[name]
end

--[[={
	@desc Executes the provided function when the specified event gets fired
	@link Connection.md
}=]]

function methods:On(name: string, callback: () -> any): Connection
	local event = getEvent(self.EventsStorage, name)
	local id = #event.Functions + 1

	local cn = connection:new(id, event)
	event.Functions[id] = callback

	return cn
end

--[[={
	@desc Triggers an event with the specified arguments
	@link void.link
}=]]

function methods:Fire(name: string, ...)
	local event = getEvent(self.EventsStorage, name)
	local functions = event.Functions

	if #functions > 0 then
		for _, func in ipairs(functions) do
			local env = getfenv(func)
			local sucess, err = pcall(coroutine.wrap(func), ...)

			if not sucess then
				testService:Error(("%s: %s"):format(name, err), env.script, 0)
			end
		end
	end

	for _, thread in ipairs(event.Threads) do
		coroutine.resume(thread, ...)
	end

	table.clear(event.Threads)
end

--[[={
	@desc The event emitter is used to manage the events of a class
	@about
		@EventsStorage This table store all the events of the class
}=]]

return baseClass:Extend(script.Name, {
	methods = methods,
	readonly = {
		EventsStorage = {},
	},
})

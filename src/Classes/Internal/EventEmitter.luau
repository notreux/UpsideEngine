local baseClass = require(script.Parent.BaseClass)
local connection = require(script.Parent.Connection)

local eventEmitter = {}
eventEmitter.__index = eventEmitter

local function getEvent(events, name)
	if not events[name] then
		events[name] = {
			Functions = {},
			Threads = {},
		}
	end

	return events[name]
end

local function cleanTrace(trace)
	local result = {}
	for line in trace:gmatch("[^\n]+") do
		if not line:find("Internal.EventEmitter") then
			table.insert(result, line)
		end
	end

	return table.concat(result, "\n")
end

local function errorHandler(err)
	local errData = err:split(": ")
	local trace = debug.traceback(errData[2])
	return cleanTrace(trace)
end

function eventEmitter.new(): EventEmitter
	local self = baseClass.new()
	self:SetClassName(script.Name)
	self.EventsStorage = {}

	return setmetatable(self, eventEmitter)
end

--[[={
	@desc Executes the provided function when the specified event gets fired
	@link Connection.md
}=]]

function eventEmitter:On(name: string, callback: () -> any): Connection
	local event = getEvent(self.EventsStorage, name)
	local id = #event.Functions + 1

	local function wrapper(...)
		local args = { ... }
		local sucess, err = xpcall(function()
			callback(unpack(args))
		end, errorHandler)

		if not sucess then
			warn(("Error: %s"):format(err))
		end
	end

	local cn = connection.new(id, event)
	event.Functions[id] = callback and wrapper or nil

	return cn
end

--[[={
	@desc Executes the provided function when the specified event gets fired, but only once
	@link Connection.md
}=]]
function eventEmitter:Once(name: string, callback: () -> any): Connection
	local event = getEvent(self.EventsStorage, name)
	local id = #event.Functions + 1

	local function wrapper(...)
		if callback then
			callback(...)
		end
		event.Functions[id] = nil
	end

	return self:On(name, wrapper)
end

--[[={
	@desc Triggers an event with the specified arguments
	@link void.link
}=]]

function eventEmitter:Fire(name: string, ...)
	local event = getEvent(self.EventsStorage, name)
	local functions = event.Functions

	if #functions > 0 then
		for _, func in functions do
			coroutine.wrap(func)(...)
		end
	end

	for _, thread in event.Threads do
		coroutine.resume(thread, ...)
	end

	table.clear(event.Threads)
end

--[[={
	@desc The event emitter is used to manage the events of a class
	@about
		@EventsStorage This table store all the events of the class
}=]]

return setmetatable(eventEmitter, baseClass)

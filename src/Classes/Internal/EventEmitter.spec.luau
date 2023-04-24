local EventEmitter = require(script.Parent.EventEmitter)

return function()
	describe(":Fire()", function()
		it("call an event", function()
			local MyEventEmitter = EventEmitter:new()
			expect(function()
				MyEventEmitter:Fire("EventName", 1)
			end).never.to.throw()
		end)
	end)

	describe(":On()", function()
		it("is executed when an event is called", function()
			local MyEventEmitter = EventEmitter:new()
			expect(function()
				MyEventEmitter:On("EventName", function(param)
					if param ~= true then
						error("receiving parameters incorrectly")
					end
				end)

				MyEventEmitter:Fire("EventName", true)
			end).never.to.throw()
		end)

		it("yield the script until the event is called", function()
			local MyEventEmitter = EventEmitter:new()
			task.delay(0.1, function()
				MyEventEmitter:Fire("EventName", true)
			end)

			expect(MyEventEmitter:On("EventName"):Wait(1)).to.equal(true)
		end)

		it("yield the script until the wait time has passed", function()
			local MyEventEmitter = EventEmitter:new()
			local works = false

			task.spawn(function()
				local t1 = os.clock()
				MyEventEmitter:On("EventName"):Wait(0.1)
				works = os.clock() - t1 >= 0.1
			end)

			task.wait(0.2)
			expect(works).to.equal(true)
		end)
	end)
end

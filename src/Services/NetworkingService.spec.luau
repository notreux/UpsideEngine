local NetworkingService = require(script.Parent.NetworkingService)

return function()
	local newNetworkingService = NetworkingService.new()

	describe(":Replicate()", function()
		it("should replicate an object", function()
			local mockObject = { Id = "123", ClassName = "MockClass", Instance = Instance.new("Part") }
			newNetworkingService:Replicate(mockObject)
			-- Add assertions to verify the object is replicated correctly
		end)
	end)

	describe(":ReplicateOnChange()", function()
		it("should replicate an object on change", function()
			local mockObject = { Id = "123", ClassName = "MockClass", Instance = Instance.new("Part") }
			local connection = newNetworkingService:ReplicateOnChange(mockObject)
			-- Add assertions to verify the object is replicated on change correctly
			connection:Disconnect()
		end)
	end)
end

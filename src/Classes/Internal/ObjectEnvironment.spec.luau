local ObjectEnvironment = require(script.Parent.ObjectEnvironment)

return function()
	describe("Constructor .new()", function()
		it("should create a new ObjectEnvironment object", function()
			local newObjectEnvironment = ObjectEnvironment.new()
			expect(newObjectEnvironment).to.be.ok()
		end)
	end)
end

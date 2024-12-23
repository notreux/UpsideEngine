local ShaderEnvironment = require(script.Parent.ShaderEnvironment)
return function()
	describe("Constructor .new()", function()
		it("should create a new ObjectEnvironment object", function()
			local newShaderEnvironment = ShaderEnvironment.new()
			expect(newShaderEnvironment).to.be.ok()
		end)
	end)
end

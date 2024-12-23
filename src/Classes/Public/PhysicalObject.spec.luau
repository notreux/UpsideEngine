local PhysicalObject = require(script.Parent.PhysicalObject)

return function()
	local newPhysicalObject = PhysicalObject.new()
	describe(":ApplyForce()", function()
		it("should apply force to the object", function()
			local initialForce = newPhysicalObject.Force
			local forceToApply = Vector2.new(10, 5)
			newPhysicalObject:ApplyForce(forceToApply)
			expect(newPhysicalObject.Force).to.equal(initialForce + forceToApply)
		end)
	end)
end

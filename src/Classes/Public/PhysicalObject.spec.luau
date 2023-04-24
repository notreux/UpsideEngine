local PhysicalObject = require(script.Parent.PhysicalObject)

return function()
	PhysicalObject = PhysicalObject:new()

	describe(":Load()", function()
		it("should load the image id", function()
			local url = "rbxassetid://0"
			PhysicalObject:Load(url)
			expect(PhysicalObject.Instance.Image).to.equal(url)
		end)
	end)
	describe(":SetChromaticAberration()", function()
		it("should set chromatic aberration", function()
			PhysicalObject:SetChromaticAberration(0.2, 0.15, Vector2.new(0.5, 0.5))
			for _, c in ipairs({ "R", "G", "B" }) do
				expect(PhysicalObject.ChromaticAberration[c]).to.be.ok()
			end

			expect(PhysicalObject.ChromaticAberrationPoint).to.equal(Vector2.new(0.5, 0.5))
			expect(PhysicalObject.ChromaticAberrationDistance).to.equal(0.15)
			expect(PhysicalObject.ChromaticAberrationIntensity).to.equal(0.2)
		end)
	end)
end

local PhysicalObject = require(script.Parent.PhysicalObject)

return function()
	local newPhysicalObject = PhysicalObject.new({ Parent = workspace })

	describe(":Load()", function()
		it("should load the image id", function()
			local url = "rbxassetid://0"
			newPhysicalObject:Load(url)
			expect(newPhysicalObject.Instance.Image).to.equal(url)
		end)
	end)
	describe(":SetChromaticAberration()", function()
		it("should set chromatic aberration", function()
			newPhysicalObject:SetChromaticAberration(0.2, 0.15, Vector2.new(0.5, 0.5))
			for _, c in ipairs({ "R", "G", "B" }) do
				expect(newPhysicalObject.ChromaticAberration[c]).to.be.ok()
			end

			expect(newPhysicalObject.ChromaticAberrationPoint).to.equal(Vector2.new(0.5, 0.5))
			expect(newPhysicalObject.ChromaticAberrationDistance).to.equal(0.15)
			expect(newPhysicalObject.ChromaticAberrationIntensity).to.equal(0.2)
		end)
	end)
end

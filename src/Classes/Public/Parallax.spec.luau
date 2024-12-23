local Parallax = require(script.Parent.Parallax)

return function()
	local parallaxInstance = Parallax.new()

	describe("constructor .new()", function()
		it("should create a new parallax instance", function()
			expect(parallaxInstance).to.be.ok()
			expect(parallaxInstance.ClassName).to.equal("Parallax")
		end)
	end)

	describe(":SetLayers()", function()
		it("should set the layers correctly", function()
			local layers = {
				{ Image = "rbxassetid://123456", Speed = 0.5 },
				{ Image = "rbxassetid://654321", Speed = 1.0 },
			}
			parallaxInstance:SetLayers(layers)
			expect(#parallaxInstance.Layers).to.equal(2)
			expect(parallaxInstance.Layers[1].Image).to.equal("rbxassetid://123456")
			expect(parallaxInstance.Layers[2].Speed).to.equal(1.0)
		end)
	end)

	describe(":Update()", function()
		it("should update the parallax effect", function()
			expect(function()
				parallaxInstance:Update()
			end).never.to.throw()
		end)
	end)
end

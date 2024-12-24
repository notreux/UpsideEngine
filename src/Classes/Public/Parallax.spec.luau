local Parallax = require(script.Parent.Parallax)

return function()
	local parallaxInstance = Parallax.new()

	describe("constructor .new()", function()
		it("should create a new parallax instance", function()
			expect(parallaxInstance).to.be.ok()
			expect(parallaxInstance.ClassName).to.equal("Parallax")
		end)
	end)

	describe(":UpdateTiles()", function()
		it("should update the parallax effect", function()
			expect(function()
				parallaxInstance:UpdateTiles()
			end).never.to.throw()
		end)
	end)

	describe(":SetTexture()", function()
		it("should set the texture of the parallax content", function()
			local texture = "rbxassetid://1234567890"
			parallaxInstance:SetTexture(texture)
			expect(parallaxInstance.Instance.Content.Image).to.equal(texture)
		end)
	end)
end

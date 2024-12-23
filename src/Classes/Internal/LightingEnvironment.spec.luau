local SceneClass = require(script.Parent.Parent.Public.Scene)

return function()
	local newScene = SceneClass.new()
	local lightingEnvironment = newScene.LightingEnvironment

	describe(":DrawPixels()", function()
		it("should draw pixels in the screen", function()
			expect(function()
				lightingEnvironment:DrawPixels()
			end).never.to.throw()
		end)
	end)

	describe(":UpdateScreen()", function()
		it("should update the properties of every pixel", function()
			expect(function()
				lightingEnvironment:UpdateScreen()
			end).never.to.throw()
		end)
	end)
end

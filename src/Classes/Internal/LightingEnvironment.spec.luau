local SceneClass = require(script.Parent.Parent.Public.Scene)

return function()
	local newScene = SceneClass.new()
	local lightingEnvironment = newScene.LightingEnvironment

	describe(":SetLightingIntensity()", function()
		it("should get the lighting intensity", function()
			expect(function()
				lightingEnvironment:SetLightingIntensity(1.4)
			end).to.throw()
			expect(function()
				lightingEnvironment:SetLightingIntensity(0.1)
			end).never.to.throw()
		end)
	end)

	describe(":GetLightingIntensity()", function()
		it("should set the lighting intensity", function()
			expect(lightingEnvironment:GetLightingIntensity()).to.be.a("number")
		end)
	end)

	describe(":DrawPixels()", function()
		it("should draw pixels in the screen", function()
			lightingEnvironment:DrawPixels({
				Pixels = 200,
				Scale = true,
				DarknessTransparency = 0.1,
				DarknessColor = Color3.fromRGB(33, 33, 33),
			})

			expect(#lightingEnvironment.Content).never.to.equal(510)
			expect(lightingEnvironment.AmbientTransparency).to.equal(0.02)
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

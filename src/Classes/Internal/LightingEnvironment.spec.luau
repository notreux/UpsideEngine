local SceneClass = require(script.Parent.Parent.Public.Scene)

return function()
	local Scene = SceneClass:new()
	local LightingEnvironment = Scene.LightingEnvironment

	describe(":SetLightingIntensity()", function()
		it("should get the lighting intensity", function()
			expect(function()
				LightingEnvironment:SetLightingIntensity(1.4)
			end).to.throw()
			expect(function()
				LightingEnvironment:SetLightingIntensity(0.1)
			end).never.to.throw()
		end)
	end)

	describe(":GetLightingIntensity()", function()
		it("should set the lighting intensity", function()
			expect(LightingEnvironment:GetLightingIntensity()).to.be.a("number")
		end)
	end)

	describe(":DrawPixels()", function()
		it("should draw pixels in the screen", function()
			LightingEnvironment:DrawPixels({
				Pixels = 200,
				Scale = true,
				DarknessTransparency = 0.1,
				DarknessColor = Color3.fromRGB(33, 33, 33),
			})

			expect(#LightingEnvironment.Content).never.to.equal(510)
			expect(LightingEnvironment.AmbientTransparency).to.equal(0.02)
		end)
	end)

	describe(":UpdateScreen()", function()
		it("should update the properties of every pixel", function()
			expect(function()
				LightingEnvironment:UpdateScreen()
			end).never.to.throw()
		end)
	end)
end

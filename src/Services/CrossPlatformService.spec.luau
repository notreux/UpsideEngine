local crossPlatformService = require(script.Parent.CrossPlatformService)
return function()
	local configs = crossPlatformService.Configs
	describe(":SetDeviceKey()", function()
		it("should set a key of a device", function()
			crossPlatformService:SetDeviceKey("Keyboard", "E", "Jump")
			expect(configs.Keyboard.E).to.equal("Jump")
		end)
	end)
	describe(":SetDeviceConfig()", function()
		it("should set one or more keys of a device", function()
			crossPlatformService:SetDeviceConfig("Keyboard", {
				E = "Jump",
				Q = "Fly",
			})
			expect(configs.Keyboard.Q).to.equal("Fly")
		end)
	end)
end

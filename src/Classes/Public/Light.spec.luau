local Light = require(script.Parent.Light)
local Scene = require(script.Parent.Scene)

return function()
	describe("Constructor .new()", function()
		it("should set the object parent to SoundService", function()
			local newScene = Scene.new({ Parent = workspace })
			local light = Light.new({ Parent = newScene })

			expect(newScene.LightingEnvironment:Get(light.Id).Id).to.equal(light.Id)
		end)
	end)
end

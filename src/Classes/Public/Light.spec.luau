local Light = require(script.Parent.Light)
local Scene = require(script.Parent.Scene)

return function()
	describe("Constructor :new()", function()
		it("should set the object parent to SoundService", function()
			Scene = Scene:new()
			Light = Light:new(Scene)

			expect(Scene.LightingEnvironment:Get(Light.Id).Id).to.equal(Light.Id)
		end)
	end)
end

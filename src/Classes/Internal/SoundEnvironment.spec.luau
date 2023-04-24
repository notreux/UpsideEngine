local SoundEnvironment = require(script.Parent.SoundEnvironment)

return function()
	describe("Constructor :new()", function()
		it("should set the object parent to SoundService", function()
			SoundEnvironment = SoundEnvironment:new()
			expect(SoundEnvironment.Instance.Parent).to.equal(game.SoundService)
		end)
	end)
end

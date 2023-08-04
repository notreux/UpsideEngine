local SoundEnvironment = require(script.Parent.SoundEnvironment)

return function()
	describe("Constructor .new()", function()
		it("should set the object parent to SoundService", function()
			local newSoundEnvironment = SoundEnvironment.new({ Parent = workspace })
			expect(newSoundEnvironment.Instance.Parent).to.equal(game.SoundService)
		end)
	end)
end

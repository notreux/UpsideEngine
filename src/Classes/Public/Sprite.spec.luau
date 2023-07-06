local Sprite = require(script.Parent.Sprite)

return function()
	Sprite = Sprite:new({
		Parent = game.StarterGui,
		SpriteSize = Vector2.new(100, 100),
	})
	
	describe(":SetSpriteSheet()", function()
		it("should set a new sprite sheet", function()
			Sprite:SetSpriteSheet("Test", "rbxassetid://0", Vector2.new(10, 10))
			expect(Sprite.Sprites["Test"]).to.be.ok()
		end)
	end)

	describe(":SetSpriteList()", function()
		it("should set a new sprite list", function()
			Sprite:SetSpriteList(
				"Test2",
				{ "rbxassetid://0", "rbxassetid://1" },
				{ Vector2.new(10, 10), Vector2.new(10, 10) }
			)
			expect(Sprite.Sprites["Test2"]).to.be.ok()
		end)
	end)

	describe(":Play()", function()
		it("should play the sprite", function()
			Sprite:Play("Test")
			expect(Sprite.IsPlaying).to.equal(true)
		end)
	end)
	describe(":Stop()", function()
		it("should stop the sprite", function()
			Sprite:Stop()
			expect(Sprite.IsPlaying).never.to.equal(true)
		end)
	end)
end

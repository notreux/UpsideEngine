local Sprite = require(script.Parent.Sprite)

return function()
	local newSprite = Sprite.new()

	describe(":SetSpriteSheet()", function()
		it("should set a new sprite sheet", function()
			newSprite:SetSpriteSheet("Test", "rbxassetid://0", Vector2.new(10, 10))
			expect(newSprite.Sprites["Test"]).to.be.ok()
		end)
	end)

	describe(":SetSpriteList()", function()
		it("should set a new sprite list", function()
			newSprite:SetSpriteList(
				"Test2",
				{ "rbxassetid://0", "rbxassetid://1" },
				{ Vector2.new(10, 10), Vector2.new(10, 10) }
			)
			expect(newSprite.Sprites["Test2"]).to.be.ok()
		end)
	end)

	describe(":Play()", function()
		it("should play the sprite", function()
			newSprite:Play("Test")
			expect(newSprite.IsPlaying).to.equal(true)
		end)
	end)

	describe(":Stop()", function()
		it("should stop the sprite", function()
			newSprite:Stop()
			expect(newSprite.IsPlaying).never.to.equal(true)
		end)
	end)
end

local character = require(script.Parent.Character)

return function()
	local newCharacter = character.new()

	describe(":UpdateHealth()", function()
		it("should update the health", function()
			newCharacter:UpdateHealth(50)
			expect(newCharacter.Health).to.equal(50)
		end)
		it("should respect the maxHealth property", function()
			expect(function()
				newCharacter:UpdateHealth(125)
			end).to.throw()
		end)
	end)

	describe(":Jump()", function()
		it("should jump with the default value", function()
			expect(function()
				newCharacter:Jump()
			end).never.to.throw()
		end)
		it("should jump with the specified value", function()
			expect(function()
				newCharacter:Jump(105)
			end).never.to.throw()
		end)
	end)

	describe(":MoveTo()", function()
		it("should move the character to the specified position", function()
			local targetPosition = Vector2.new(100, 100)
			expect(function()
				newCharacter:MoveTo(targetPosition)
			end).never.to.throw()
		end)
	end)

	describe(":Fire()", function()
		it("should fire the 'Died' event when health is updated to 0", function()
			local diedFired = false
			newCharacter:On("Died", function()
				diedFired = true
			end)
			newCharacter:UpdateHealth(0)
			expect(diedFired).to.equal(true)
		end)

		it("should fire the 'HealthChanged' event when health is updated", function()
			local healthChangedFired = false
			newCharacter:On("HealthChanged", function()
				healthChangedFired = true
			end)
			newCharacter:UpdateHealth(50)
			expect(healthChangedFired).to.equal(true)
		end)
	end)
end

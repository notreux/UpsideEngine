local Request = require(script.Parent.Request)

return function()
	local newRequest = Request.new(1, {
		name = "aa",
		id = 2,
		className = "Sprite",
		properties = {
			object = { SpriteSpeed = 0.5 },
			instance = { BackgroundTransparency = 0.5 },
		},
	})

	describe("Constructor .new()", function()
		it("should send the provided information to the client|server", function()
			expect(newRequest.ClientId).to.equal(1)
			expect(typeof(newRequest.Content)).to.equal("table")
		end)
	end)
	describe(":Approve()", function()
		it("should replicate the request to others clients", function()
			expect(function()
				newRequest:Approve()
			end).never.to.throw()
		end)
	end)
	describe(":GetClient()", function()
		it("should return the player instance of the client request", function()
			expect(function()
				newRequest:GetClient()
			end).never.to.throw()
		end)
	end)
end

local Request = require(script.Parent.Request)

return function()
	local newRequest = Request.new(1, {
		Name = "TestObject",
		Id = 2,
		ClassName = "Sprite",
		ObjectProperties = {
			SpriteSpeed = 0.5,
		},
		Instance = {
			BackgroundTransparency = 0.5,
		},
	})

	describe("Constructor .new()", function()
		it("should send the provided information to the client|server", function()
			expect(newRequest.ClientId).to.equal(1)
			expect(typeof(newRequest.Content)).to.equal("table")
		end)
	end)

	describe(":Approve()", function()
		it("should replicate the request to other clients", function()
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

	describe(":Send()", function()
		it("should send the request to the server", function()
			expect(function()
				newRequest:Send({
					Id = 3,
					Name = "AnotherObject",
					ClassName = "Sprite",
					ObjectProperties = {
						SpriteSpeed = 1.0,
					},
					Instance = {
						BackgroundTransparency = 0.3,
					},
				})
			end).never.to.throw()
		end)
	end)
end

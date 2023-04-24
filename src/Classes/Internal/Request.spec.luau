local Request = require(script.Parent.Request)
local Test = {
	name = "aa",
	id = 2,
	className = "Sprite",
	properties = {
		object = { SpriteSpeed = 0.5 },
		instance = { BackgroundTransparency = 0.5 },
	},
}

return function()
	Request = Request:new(1, Test)

	describe("Constructor :new()", function()
		it("should send the provided information to the client|server", function()
			expect(Request.ClientId).to.equal(1)
			expect(typeof(Request.Content)).to.equal("table")
		end)
	end)
	describe(":Approve()", function()
		it("should replicate the request to others clients", function()
			expect(function()
				Request:Approve()
			end).never.to.throw()
		end)
	end)
	describe(":Accept()", function()
		it("should build the request content", function()
			local result = Request:Accept()
			expect(typeof(result)).to.equal("table")
		end)
	end)
	describe(":GetClient()", function()
		it("should return the player instance of the client request", function()
			expect(function()
				Request:GetClient()
			end).never.to.throw()
		end)
	end)
end

local upsideEngine = script.Parent.Parent.Parent
local NetworkingService = require(upsideEngine.Services.NetworkingService)
local Sprite = require(upsideEngine.Classes.Public.Sprite)
local Request = require(upsideEngine.Classes.Internal.Request)

return function()
	local object = Sprite.new()
	local newRequest = Request.new(1, {
		Name = "TestObject",
		ClassName = object.ClassName,
		ObjectId = object.Id,
		ObjectProperties = {
			Active = object.Active,
		},
		Instance = {
			Position = UDim2.fromOffset(100, 300),
		},
	})

	NetworkingService.PlayersData[1] = {}
	NetworkingService.PlayersData[3] = {}

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
					ObjectId = 3,
					Name = "AnotherObject",
					ClassName = "Sprite",
					ObjectProperties = {
						IsPlaying = false,
					},
					Instance = {
						Size = UDim2.fromOffset(200, 500),
					},
				})
			end).never.to.throw()
		end)
	end)
end

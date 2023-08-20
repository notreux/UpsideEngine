local UpsideEngine = require(script.Parent)

return function()
	describe(".new()", function()
		it("should create a new object", function()
			local object = UpsideEngine.new("Sound")

			expect(object.Id).to.be.ok()
		end)
	end)
	describe(".GetService()", function()
		it("should get a service", function()
			local service = UpsideEngine.GetService("SceneManager")
			expect(service.Id).to.be.a("string")
		end)
	end)
end

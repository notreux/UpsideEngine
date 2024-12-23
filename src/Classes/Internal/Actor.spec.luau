local Actor = require(script.Parent.Actor)

return function()
	describe("Actor", function()
		local actorInstance
		local mockModule = Instance.new("ModuleScript")

		beforeAll(function()
			actorInstance = Actor.new(mockModule)
		end)

		afterAll(function()
			actorInstance.instance:Destroy()
		end)

		it("should create a new actor instance", function()
			expect(actorInstance).to.be.ok()
			expect(actorInstance.instance).to.be.ok()
			expect(actorInstance.instance:IsA("Actor")).to.equal(true)
		end)

		it("should set and update variables correctly", function()
			actorInstance:SetVariable("testVar", 123)
			expect(actorInstance.__cache["testVar"]).to.equal(123)

			actorInstance:SetVariable("testVar", 456)
			expect(actorInstance.__cache["testVar"]).to.equal(456)
		end)

		it("should execute commands correctly", function()
			actorInstance:Execute("testCommand")
		end)

		it("should execute commands every step correctly", function()
			actorInstance:ExecuteEveryStep("testCommandEveryStep")
		end)
	end)
end

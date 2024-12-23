local actrees = require(script.Parent.Actrees)
local actor = require(script.Parent.Actor)

return function()
	local mockModule = Instance.new("ModuleScript")
    describe("actrees", function()
		it("should add actors correctly", function()
			local tree = actrees.new()
			local testActor = actor.new(mockModule)
			tree:AddActor(testActor)
			expect(#tree.__actors).to.equal(1)
			expect(tree.__actors[1]).to.equal(testActor)
		end)

		it("should set variables without errors", function()
			local tree = actrees.new()
			local testActor = actor.new(mockModule)
			tree:AddActor(testActor)
			
			expect(function()
				tree:SetVariable("testVar", 42)
			end).never.to.throw()
		end)

		it("should iterate over actors correctly", function()
			local tree = actrees.new()
			local testActor1 = actor.new(mockModule)
			local testActor2 = actor.new(mockModule)
			tree:AddActor(testActor1)
			tree:AddActor(testActor2)

			local count = 0
			for _, actor in tree do
				count = count + 1
			end

			expect(count).to.equal(2)
		end)
	end)
end

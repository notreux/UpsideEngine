local BaseObject = require(script.Parent.BaseObject)
local Scene = require(script.Parent.Parent.Public.Scene)

return function()
	describe("constructor :new()", function()
		it("should use the first arg as parent", function()
			local parent = Instance.new("Frame")
			local obj = BaseObject:new(parent)

			expect(obj.Instance.Parent).to.equal(parent)
		end)

		it("should be added to the parent scene", function()
			local scene = Scene:new()
			local obj = BaseObject:new(scene)

			expect(obj.Scene).to.equal(scene.Id)
			expect(scene.Objects[obj.Id].Id).to.equal(obj.Id)
		end)
	end)

	describe(":AddTag()", function()
		it("should add a Tag", function()
			local obj = BaseObject:new()
			obj:AddTag("Summit")

			expect(obj:HasTag("Summit")).to.equal(true)
		end)
	end)

	describe(":RemoveTag()", function()
		it("should remove a Tag", function()
			local obj = BaseObject:new()
			obj:AddTag("Disconnected")
			obj:RemoveTag("Disconnected")

			expect(obj:HasTag("Disconnected")).never.to.equal(true)
		end)
	end)

	describe(":HasTag()", function()
		it("should check if an object has a tag", function()
			local obj = BaseObject:new()
			expect(obj.Tags.Bonfire).never.to.equal(true)
		end)
	end)

	describe(":Set()", function()
		it("should set properties", function()
			local obj = BaseObject:new(workspace)
			obj:Set({
				BackgroundTransparency = 1,
			})
			expect(typeof(obj.Instance)).to.equal("Instance")
		end)
	end)
end

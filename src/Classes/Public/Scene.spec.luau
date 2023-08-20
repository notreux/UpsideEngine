local Scene = require(script.Parent.Scene)
local PhysicalObject = require(script.Parent.PhysicalObject)

return function()
	local newScene = Scene.new()
	local newPhysicalObject = PhysicalObject.new()
	newPhysicalObject:AddTag("NewTag")
	newPhysicalObject:SetScene(newScene)

	describe(":GetTaggedObjects()", function()
		it("should get all tagged objects", function()
			newPhysicalObject:SetScene(newScene)
			expect(newScene:GetTaggedObjects("NewTag")[1].Id).to.equal(newPhysicalObject.Id)
		end)
	end)
	describe(":Raycast()", function()
		it("should throw a ray", function()
			expect(function()
				newScene:Raycast({
					From = Vector2.new(0.5, 0.5),
					To = Vector2.new(0.5, 0.5) * 5,
					FilterType = "Whitelist",
				})
			end).never.to.throw()
		end)
	end)
end

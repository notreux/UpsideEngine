local Sound = require(script.Parent.Sound)
local scene = require(script.Parent.Scene)
local PhysicalObject = require(script.Parent.PhysicalObject)

return function()
	local newScene = scene.new()
	local newSound = Sound.new()
	newSound:SetScene(newScene)

	local newPhysicalObject = PhysicalObject.new()
	newPhysicalObject:SetScene(newScene)

	describe(":SetSubject()", function()
		it("should set a new subject", function()
			newSound:SetSubject(newPhysicalObject)
			expect(newSound.Subject.Id).to.equal(newPhysicalObject.Id)
		end)
	end)
end

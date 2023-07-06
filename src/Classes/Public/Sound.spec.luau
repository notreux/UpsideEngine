local Sound = require(script.Parent.Sound)
local Scene = require(script.Parent.Scene)
local PhysicalObject = require(script.Parent.PhysicalObject)

return function()
	Scene = Scene:new()
	Sound = Sound:new({ Parent = Scene })
	PhysicalObject = PhysicalObject:new({ Parent = Scene })

	describe(":SetSubject()", function()
		it("should set a new subject", function()
			Sound:SetSubject(PhysicalObject)
			expect(Sound.Subject.Id).to.equal(PhysicalObject.Id)
		end)
	end)
end

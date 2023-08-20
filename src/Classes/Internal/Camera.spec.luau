local Scene = require(script.Parent.Parent.Public.Scene)
local physicalObject = require(script.Parent.Parent.Public.PhysicalObject)

return function()
	local newScene = Scene.new()
	local camera = newScene.Camera

	describe(":GetPosition()", function()
		it("should get the camera position", function()
			expect(camera:GetPosition()).to.equal(newScene.Instance.GameFrame.Position)
		end)
	end)

	describe(":SetPosition()", function()
		it("should set the camera position", function()
			local position = UDim2.fromScale(0.45, 0.45)
			camera:SetPosition(position)
			expect(camera:GetPosition()).to.equal(position)
		end)
	end)

	describe(":SetSubject()", function()
		it("should set the camera subject", function()
			local subject = physicalObject.new()
			camera:SetSubject(subject)
			expect(camera.Subject).to.equal(subject)
		end)
	end)
end

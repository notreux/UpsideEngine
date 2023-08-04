local Scene = require(script.Parent.Parent.Public.Scene)
local PhysicalObject = require(script.Parent.Parent.Public.PhysicalObject)

return function()
	local newScene = Scene.new({ Parent = workspace })
	local camera = newScene.Camera

	describe(":GetPosition()", function()
		it("should get the camera position", function()
			expect(camera:GetPosition()).to.equal(newScene.Instance.Position)
		end)
	end)

	describe(":SetPosition()", function()
		it("should set the camera position", function()
			local Position = UDim2.fromScale(0.45, 0.45)
			camera:SetPosition(Position)
			expect(camera:GetPosition()).to.equal(Position)
		end)
	end)

	describe(":SetSubject()", function()
		it("should set the camera subject", function()
			local Subject = PhysicalObject.new({ Parent = newScene })
			camera:SetSubject(Subject)
			expect(camera.Subject).to.equal(Subject)
		end)
	end)
end

local Scene = require(script.Parent.Parent.Public.Scene)
local PhysicalObject = require(script.Parent.Parent.Public.PhysicalObject)

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
			local subject = PhysicalObject.new()
			camera:SetSubject(subject)
			expect(camera.Subject).to.equal(subject)
		end)
	end)

	describe(":LookTo()", function()
		it("should position the camera centered relative to the provided object", function()
			local object = PhysicalObject.new()
			object.Instance.Position = UDim2.fromOffset(100, 100)
			camera:LookTo(object)

			local resolution = workspace.CurrentCamera.ViewportSize
			local center = resolution / 2

			local target = Vector2.new(object.Instance.Position.X.Offset, object.Instance.Position.Y.Offset)
			local result = center + (center - target)
			
			expect(camera.LocalPosition).to.equal(UDim2.fromOffset(result.X, result.Y))
		end)
	end)
end

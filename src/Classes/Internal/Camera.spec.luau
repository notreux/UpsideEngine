local Scene = require(script.Parent.Parent.Public.Scene)
local PhysicalObject = require(script.Parent.Parent.Public.PhysicalObject)
local Camera

return function()
	Scene = Scene:new()
	Camera = Scene.Camera

	describe(":GetPosition()", function()
		it("should get the camera position", function()
			expect(Camera:GetPosition()).to.equal(Scene.Instance.Position)
		end)
	end)

	describe(":SetPosition()", function()
		it("should set the camera position", function()
			local Position = UDim2.fromScale(0.45, 0.45)
			Camera:SetPosition(Position)
			expect(Camera:GetPosition()).to.equal(Position)
		end)
	end)

	describe(":SetSubject()", function()
		it("should set the camera subject", function()
			local Subject = PhysicalObject:new({ Parent = Scene })
			Camera:SetSubject(Subject)
			expect(Camera.Subject).to.equal(Subject)
		end)
	end)
end

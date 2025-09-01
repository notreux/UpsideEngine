local Path = require(script.Parent.Parent.Parent.Lib.Util.Internal.Path)
local Shader = require(script.Parent.Shader)

return function()
	local newShader = Shader.new()

	describe(":SetMirrorSource()", function()
		it("should set the mirror source object", function()
			local mockObject = { Instance = Instance.new("ImageLabel") }
			newShader:SetMirrorSource(mockObject)
			expect(newShader.MirrorSource).to.equal(mockObject.Instance)
		end)
	end)

	describe(":SetSource()", function()
		it("should set the shader source path", function()
			local mockModuleScript = Instance.new("ModuleScript")
			mockModuleScript.Parent = workspace
			newShader:SetSource(mockModuleScript)

			local object = Path.readRoute(newShader.Path)
			expect(object).to.equal(mockModuleScript)
		end)
	end)
end

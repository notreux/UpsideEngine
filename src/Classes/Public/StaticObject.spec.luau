local Scene = require(script.Parent.Scene)
local StaticObject = require(script.Parent.StaticObject)
local Shader = require(script.Parent.Shader)

return function()
	local scene = Scene.new()
	local staticObject = StaticObject.new()
	staticObject:SetScene(scene)

	describe("constructor .new()", function()
		it("should create a new static object instance", function()
			expect(staticObject).to.be.ok()
			expect(staticObject.ClassName).to.equal("StaticObject")
		end)
	end)

	describe(":SetShader()", function()
		it("should set the shader for the static object", function()
			local shader = Shader.new()
			staticObject:SetShader(shader)
			expect(staticObject.Shader).to.equal(shader)
		end)
	end)

	describe(":Load()", function()
		it("should load an image for the static object", function()
			local url = "rbxassetid://123456"
			staticObject:Load(url)
			expect(staticObject.Instance.Image).to.equal(url)
		end)
	end)

	describe(":SetChromaticAberration()", function()
		it("should set chromatic aberration", function()
			staticObject:SetChromaticAberration(0.2, 0.15, Vector2.new(0.5, 0.5))
			for _, c in { "R", "G", "B" } do
				expect(staticObject.ChromaticAberration[c]).to.be.ok()
			end

			expect(staticObject.ChromaticAberrationPoint).to.equal(Vector2.new(0.5, 0.5))
			expect(staticObject.ChromaticAberrationDistance).to.equal(0.15)
			expect(staticObject.ChromaticAberrationIntensity).to.equal(0.2)
		end)

		it("should set chromatic aberration with no error", function()
			expect(function()
				staticObject:SetChromaticAberration(0.5, 0.1, Vector2.new(0.5, 0.5))
			end).never.to.throw()
		end)

		it("should disable chromatic aberration when intensity is 0", function()
			staticObject:SetChromaticAberration(0)
			expect(staticObject.ChromaticAberration.R).to.equal(nil)
		end)
	end)
end

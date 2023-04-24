local data = require(script.Parent.Parent.Parent.AppData.Data)
local baseClass = require(script.Parent.BaseClass)

return function()
	describe("constructor :new()", function()
		it("should create a new object", function()
			local object = baseClass:new()
			expect(data.restricted[object.Id]).to.be.ok()
		end)
	end)

	describe(":SetName()", function()
		it("should rename the object", function()
			local object = baseClass:new()
			object:SetName("NewName")
			expect(object.Name).to.equal("NewName")
		end)
	end)

	describe(":Destroy()", function()
		it("Destroys the object", function()
			expect(function()
				local object = baseClass:new()
				object:Destroy()
			end)
		end)
	end)

	describe(":Extend()", function()
		local methods = {}
		local constructor = {}

		function constructor:Test(value)
			addReadonly({
				NewReadonlyProperty = value,
			})
		end

		function methods:Read(property)
			return self[property]
		end

		local class = baseClass:Extend("MyExtendedClass", {
			methods = methods,
			constructors = constructor,
			readonly = { ReadonlyProperty = 1 },
			rules = { RuleProperty = "string" },
			private = { PrivateProperty = true },
		})

		it("should extend a class", function()
			expect(data.restricted[class.Id]).to.be.ok()
		end)

		it("the property 'ReadonlyProperty' should be read only", function()
			expect(function()
				class.ReadonlyProperty = 2
			end).to.throw()
		end)

		it("the property 'RuleProperty' only should accept values of the same type", function()
			expect(function()
				class.RuleProperty = true
			end).to.throw()
		end)

		it("the property 'PrivateProperty' cant be accessed externally", function()
			expect(function()
				class.PrivateProperty = false
			end).to.throw()
		end)

		it("should use the defined ClassName", function()
			expect(class.ClassName).to.equal("MyExtendedClass")
		end)

		it("should inherit a property", function()
			expect(class.ReadonlyProperty).to.equal(1)
		end)

		it("should build an object with the extended class constructor", function()
			local object = class:new(5)
			expect(object:Read("NewReadonlyProperty")).to.equal(5)
		end)
	end)
end

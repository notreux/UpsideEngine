local baseClass = require(script.Parent.Parent.Internal.BaseClass)
local path = require(script.Parent.Parent.Parent.Private.Util.Internal.Path)
local shader = {}
shader.__index = shader

function shader.new(): EventEmitter
	local self = baseClass.new()
	self:SetClassName(script.Name)
	self.Enabled = true
	self.Path = ""

	return setmetatable(self, shader)
end

--[[={
	@desc Sets the module script which is going to be used as shader source
	@link void.md
}=]]

function shader:SetSource(file: ModuleScript)
	self.Path = path.getRoute(file)
end

--[[={
	@desc 
	!!! warning 
		Shaders are very cpu-intensive, so it is not recommended to use them with high resolution images
		and not to use too many shaders.

		If you need to scale an image, do it in the studio, instead of doing it in the editing program, 
		this will lighten a lot the work for the cpu.	

		_____
		This class is used to modify how an object is renderized
	@about
		@Path This property stores the shader path
        @Enabled This property determines if the shader is enabled
}=]]

return setmetatable(shader, baseClass)

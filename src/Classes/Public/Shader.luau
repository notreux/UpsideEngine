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
	@desc The event emitter is used to manage the events of a class
	@about
		@Path This property stores the shader path
        @Enabled This property determines if the shader is enabled
        @Canvas This property stores the shader information to draw
}=]]

return setmetatable(shader, baseClass)

local physicalObject = require(script.Parent.PhysicalObject)

local fluid = {}
fluid.__index = fluid

function fluid.new()
	local self = physicalObject.new()
	self:SetClassName(script.Name)
	self.Density = 2
	self.Viscosity = 5
	self.WavesAmplitude = 1
	self.WavesSpeed = 0.1

	return setmetatable(self, fluid)
end

--[[={
	@desc This class is used to simulate fluids
	@about
		@Density Indicates how much dense the fluid should be. Higher values indicate a denser fluid, 
        affecting buoyancy and movement of objects within the fluid
		@Viscosity Determines the flow resistance of the fluid. Higher values indicate a thicker fluid, 
        affecting the speed at which objects can move through it
		@WavesAmplitude Specifies the magnitude of the fluid waves. These waves are not visible but influence buoyancy and object stability.
		@WavesSpeed Determines how fast the waves should move
}=]]

return setmetatable(fluid, physicalObject)

local staticObject = require(script.Parent.StaticObject)
local light = {}
light.__index = light

--[[={
	@link Light.md
}=]]

function light.new(): Light
	local self = staticObject.new()
	self:SetClassName(script.Name)
	self.Shape = "PointLight"
	self.Rotation = 0
	self.Angle = 90
	self.Color = Color3.fromRGB(255, 255, 255)
	self.Range = 50
	self.Brightness = 0
	self.Transparency = 0.85
	self.Inverted = false

	return setmetatable(self, light)
end

--[[={
	@desc This class is used to illuminate areas in the darkness
	@about
		@TrackCollisions Its a property of PhysicalObject, in this class is marked as readonly and is set false to optimizate
		@Range Is the range of the light
		@Transparency Is the transparency of the light
		@Shape Is how the light should be shown, there are two modes "PointLight" and "SpotLight"
		@Brightness Is the brightness of the light
		@Color The color you want the light to have
		@Rotation
		!!!warning
			Only works on Spotlights

		Determines how many degrees the Light is rotated
		@Angle
		!!!warning
			Only works on Spotlights

		Determines the light area size
		@Inverted 
		!!!warning
			Only works on Pointlights

		Inverts the light source
		@Track If this property is set to true the light is tracked, so it appears on the screen, if it is disabled and it was tracked at some point,
		it will appear on the screen but if at any time another light enters in the range of this light, this light will start to modify the shape of the initial light, that's because we can say that when we disable the
		the shape of the initial light, that is because it could be said that when we disable the Track property what remains on the screen is the trace of the light.
}=]]

return setmetatable(light, staticObject)

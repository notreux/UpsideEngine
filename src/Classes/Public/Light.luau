local physicalObject = require(script.Parent.PhysicalObject)
local methods = {}
local constructor = {}

--[[={
	@link Light.md
}=]]

function constructor:Light(data: BaseObjectParams)
	local scene = data.Parent
	if scene and scene.LightingEnvironment then
		scene.LightingEnvironment:AddOne(self, self.Id)
	end
end

--[[={
	@desc This class is used to illuminate areas in the darkness
	@about
		@TrackCollisions Its a property of PhysicalObject, in this class is marked as readonly and is set false to optimizate
		@Range Is the range of the light
		@Brightness Is the brightness of the light
		@Track If this property is set to true the light is tracked, so it appears on the screen, if it is disabled and it was tracked at some point,
		it will appear on the screen but if at any time another light enters in the range of this light, this light will start to modify the shape of the initial light, that's because we can say that when we disable the
		the shape of the initial light, that is because it could be said that when we disable the Track property what remains on the screen is the trace of the light.
}=]]

return physicalObject:Extend(script.Name, {
	constructor = constructor,
	methods = methods,
	readonly = {
		TrackCollisions = false,
	},
	rules = {
		Color = Color3.fromRGB(255, 255, 255),
		Range = 50,
		Brightness = 1,
		Track = true,
	},
})

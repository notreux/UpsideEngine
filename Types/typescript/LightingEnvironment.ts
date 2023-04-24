export type LightingEnvironment = {
AmbientColor: Color3
AmbientTransparency: number
UpdateFrequency: number
PixelIndex: number
Distance: number
InstanceType: string
Pixels: 	{ 	},
LightingIntensity: number
new(self: LightingEnvironment, parent: Frame): LightingEnvironment
DrawPixels(self: LightingEnvironment, settings: any): null
SetLightingIntensity(self: LightingEnvironment, value: number): null
GetLightingIntensity(self: LightingEnvironment): null
UpdateScreen(self: LightingEnvironment): null
}


module.exports = {}
export type LightingEnvironment = Environment & {
AmbientColor: Color3,
AmbientTransparency: number,
UpdateFrequency: number,
PixelIndex: number,
Distance: number,
InstanceType: string,
Pixels: 	{ 	},
LightingIntensity: number,
new: (self: LightingEnvironment, parent: Frame) -> LightingEnvironment,
DrawPixels: (self: LightingEnvironment, settings: any) -> nil,
SetLightingIntensity: (self: LightingEnvironment, value: number) -> nil,
GetLightingIntensity: (self: LightingEnvironment) -> nil,
UpdateScreen: (self: LightingEnvironment) -> nil,
}


return {}
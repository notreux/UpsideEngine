export type Particle = BaseObject & {
Angle: Vector2,
InstanceType: string,
Subject: Character,
MaxRate: number,
Units: number,
Properties: 	{
 Image: string,
	},
Goals: 	{
 Size: UDim2,
ImageTransparency: number,
	},
Info: TweenInfo,
TrackLight: boolean,
CanCollide: boolean,
Enabled: boolean,
LightBrightness: number,
LightRange: number,
Range: number,
LifeTime: number,
Clock: number,
Rate: number,
SetSubject: (self: Particle, subject: Character) -> nil,
SetAngle: (self: Particle, Angle: Vector2) -> nil,
SetMaxRate: (self: Particle, maxRate: number) -> nil,
Emit: (self: Particle, rate: number) -> nil,
}


return {}
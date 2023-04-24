export type Light = PhysicalObject & {
TrackCollisions: boolean,
Color: Color3,
Range: number,
Brightness: number,
Track: boolean,
new: (self: Light, scene: Scene) -> Light,
}


return {}
export type PhysicalObject = BaseObject & {
InstanceType: string,
ChromaticAberrationIntensity: number,
ChromaticAberrationDistance: number,
ChromaticAberrationPoint: Vector2,
ChromaticAberration: 	{ 	},
Collisions: 	{ 	},
ChromaticAberrationConnection: boolean,
CollisionBlacklist: 	{ 	},
Hitbox: 	{ 	},
Mass: number,
HitboxScale: number,
CollisionGroup: number,
Anchored: boolean,
CanCollide: boolean,
IsGrounded: boolean,
TrackCollisions: boolean,
HitboxShape: string,
Force: Vector2,
Velocity: Vector2,
new: (self: PhysicalObject) -> PhysicalObject,
SetHitboxShape: (self: PhysicalObject, shape: string) -> nil,
Load: (self: PhysicalObject, url: string) -> nil,
SetChromaticAberration: (self: PhysicalObject, Intensity: number, Distance: number, Point: Vector2) -> nil,
}


return {}
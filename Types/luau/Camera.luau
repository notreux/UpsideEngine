export type Camera = EventEmitter & {
Subject: Character,
FollowSubject: boolean,
new: (self: Camera, scene: Scene) -> Camera,
GetPosition: (self: Camera) -> nil,
SetPosition: (self: Camera, udim2: UDim2) -> nil,
SetSubject: (self: Camera, subject: Character) -> nil,
LookTo: (self: Camera, object: PhysicalObject) -> nil,
}


return {}
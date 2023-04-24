export type Camera = {
Subject: Character
FollowSubject: boolean
new(self: Camera, scene: Scene): Camera
GetPosition(self: Camera): null
SetPosition(self: Camera, udim2: UDim2): null
SetSubject(self: Camera, subject: Character): null
LookTo(self: Camera, object: PhysicalObject): null
}


module.exports = {}
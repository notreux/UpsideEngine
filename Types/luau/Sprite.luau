export type Sprite = PhysicalObject & {
IsPlaying: boolean,
Active: 	{
 Name: string,
CurrentFrame: Vector2,
SecondsPerFrame: number,
NextStepReady: boolean,
	},
SecondsPerFrame: number,
Sprites: 	{ 	},
new: (self: Sprite, parent: Scene, size: Vector2) -> Sprite,
SetSpriteSheet: (self: Sprite, name: string, url: string, frames: Vector2) -> nil,
SetSpriteList: (self: Sprite, name: string, list: Array<string>) -> nil,
Play: (self: Sprite, name: string, secondsPerFrame: number?) -> nil,
Stop: (self: Sprite) -> nil,
}


return {}
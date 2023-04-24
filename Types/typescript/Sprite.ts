export type Sprite = {
IsPlaying: boolean
Active: 	{
 Name: string,
CurrentFrame: Vector2,
SecondsPerFrame: number,
NextStepReady: boolean,
	},
SecondsPerFrame: number
Sprites: 	{ 	},
new(self: Sprite, parent: Scene, size: Vector2): Sprite
SetSpriteSheet(self: Sprite, name: string, url: string, frames: Vector2): null
SetSpriteList(self: Sprite, name: string, list: Array<string>): null
Play(self: Sprite, name: string, secondsPerFrame: number?): null
Stop(self: Sprite): null
}


module.exports = {}
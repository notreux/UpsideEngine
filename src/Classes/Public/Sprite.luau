local contentProvider = game:GetService("ContentProvider")
local physicalObject = require(script.Parent.PhysicalObject)

local sprite = {}
sprite.__index = sprite

--[[={
	@desc The second parameter is the size of a cell of every frame of an sprite sheet, this can be changed using the .ImageRectSize property of the object Instance 
	@link Sprite.md
}=]]

function sprite.new(): Sprite
	local self = physicalObject.new()
	self:SetClassName(script.Name)
	self.IsPlaying = false
	self.SecondsPerFrame = 0.05
	self.Sprites = {}
	self.Active = {
		Name = "",
		CurrentFrame = Vector2.zero,
		SecondsPerFrame = 0,
		NextStepReady = true,
	}

	return setmetatable(self, sprite)
end

--[[={
	@desc Adds a new sprite sheet to the object, the sprite will be played using as reference the amount of cells in the X axe and the Y axe, this must be provided in the third paramether as a Vector2
	@link void.link
}=]]

function sprite:SetSpriteSheet(name: string, url: string, frames: Vector2)
	task.defer(contentProvider.PreloadAsync, contentProvider, { url })
	self.Sprites[name] = {
		Url = url,
		Frames = frames - Vector2.one,
	}
end

--[[={
	@desc Adds a new sprite list to the object, it will play the animation using the order in the provided list, this list must contain the urls of every frame
	@link void.link
}=]]

function sprite:SetSpriteList(name: string, list: Array<string>)
	task.defer(contentProvider.PreloadAsync, contentProvider, list)
	self.Sprites[name] = {
		List = list,
	}
end

--[[={
	@desc Plays the specified sprite if exists, if secondsEveryFrame is specified it will be used instead of .SecondsPerFrame
	@link void.link
}=]]

function sprite:Play(name: string, secondsPerFrame: number?)
	self.IsPlaying = true
	self.Active = {
		Name = name,
		SecondsPerFrame = secondsPerFrame or self.SecondsPerFrame,
		NextStepReady = true,
		CurrentFrame = Vector2.zero,
	}
end

--[[={
	@desc Stops the reproduction of the current playing sprite sheet or sprite list
	@link void.link
}=]]

function sprite:Stop()
	self.IsPlaying = false
end

--[[={
	@desc This class is used to play sounds
	@about
		@IsPlaying Indicates if the sprite is playing
		@Sprites This table stores all sprite sheets and sprite lists 
		@SecondsPerFrame This is the time to wait between frame and frame
		@Active This table stores information about the active spritesheet
	@events
		@FrameChanging This event is fired before the current frame changes, it will provide the new frame position as a Vector2
}=]]

return setmetatable(sprite, physicalObject)

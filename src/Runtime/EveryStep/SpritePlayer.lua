local isOutSceen = require(script.Parent.Parent.Parent.Private.Util.Math.IsOutSceen)
local function axeStep(active, axe, max)
	local index = active.CurrentFrame[axe]
	local value = index <= max - 1 and index + 1 or 0

	active.CurrentFrame =
		Vector2.new(axe == "X" and value or active.CurrentFrame["X"], axe == "Y" and value or active.CurrentFrame["Y"])
end

local function spriteListStep(self, sprite, seconds)
	local active = self.Active
	local instance = self.Instance

	local list = sprite.List
	axeStep(active, "X", #list)

	instance.Image = list[active.CurrentFrame.X]
end

local function SpriteSheetStep(self, sprite, active)
	local instance = self.Instance
	local frames = sprite.Frames

	if frames.X == active.CurrentFrame.X then
		axeStep(active, "Y", frames.Y)
	end

	axeStep(active, "X", frames.X)
	instance.ImageRectOffset = instance.ImageRectSize * active.CurrentFrame
end

local function play(self, active)
	local sprite = self.Sprites[active.Name]
	local instance = self.Instance

	local spriteStep = sprite.Url and SpriteSheetStep or spriteListStep
	active.NextStepReady = false

	if sprite.Url then
		instance.Image = sprite.Url
	end

	spriteStep(self, sprite, active)
	task.wait(active.SecondsPerFrame)

	active.NextStepReady = true
end

local function shouldSkip(object, active)
	return not (object:IsA("Sprite") and object.IsPlaying and active.NextStepReady and object.Sprites[active.Name])
		or isOutSceen(object.Instance.AbsolutePosition, object.Instance.AbsoluteSize)
end

return function(scene, delta)
	for _, object in scene.Objects do
		local active = object.Active
		if shouldSkip(object, active) then
			continue
		end
		coroutine.wrap(play)(object, active)
	end
end

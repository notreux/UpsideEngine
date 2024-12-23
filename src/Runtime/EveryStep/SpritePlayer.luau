local IsOutScreen = require(script.Parent.Parent.Parent.Private.Util).IsOutScreen
local function axeStep(active, axe, max)
	local index = active.CurrentFrame[axe]
	local value = index <= max - 1 and index + 1 or 0

	active.CurrentFrame =
		Vector2.new(axe == "X" and value or active.CurrentFrame["X"], axe == "Y" and value or active.CurrentFrame["Y"])
end

local function spriteListStep(self, sprite, seconds)
	local active = self.Active
	local instance = self.Instance
	local shader = sprite.Shader

	local list = sprite.List
	axeStep(active, "X", #list - 1)

	if not shader.Enabled then
		instance.Image = list[active.CurrentFrame.X + 1]
		return
	end

	instance:SetAttribute("url", list[active.CurrentFrame.X + 1])
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

	local shader = self.Shader
	local spriteStep = sprite.Url and SpriteSheetStep or spriteListStep
	active.NextStepReady = false

	if sprite.Url and shader.Enabled then
		instance:SetAttribute("url", sprite.Url)
	elseif sprite.Url and not shader.Enabled then
		instance.Image = sprite.Url
	end

	spriteStep(self, sprite, active)
	task.wait(active.SecondsPerFrame)

	active.NextStepReady = true
end

local function shouldSkip(object, active)
	return not (object:IsA("Sprite") and object.IsPlaying and active.NextStepReady and object.Sprites[active.Name])
		or IsOutScreen(object.Instance.AbsolutePosition, object.Instance.AbsoluteSize)
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

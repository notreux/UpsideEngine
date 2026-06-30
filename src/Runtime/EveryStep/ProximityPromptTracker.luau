local TweenService = game:GetService("TweenService")
local getDistance = require(script.Parent.Parent.Parent.Lib.Util.Math.GetDistance)
local proximityPrompts = {}
local proximityInRange = {}

local function setProximityPromptVisible(proximityPrompt, visible)
	local targetTransparency = if visible then 0 else 1
	local tweenInfo = TweenInfo.new(proximityPrompt.FadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local elements = {
		proximityPrompt.Instance,
		proximityPrompt.Label,
	}

	if visible and not proximityPrompt.IsPlaying then
		proximityPrompt:Play("idle")
	end

	for _, element in elements do
		local tween = TweenService:Create(
			element,
			tweenInfo,
			if element:IsA("ImageLabel")
				then { ImageTransparency = targetTransparency }
				else { TextTransparency = targetTransparency }
		)

		tween:Play()
		tween.Completed:Once(function()
			tween:Destroy()
			if targetTransparency == 1 then
				proximityPrompt:Stop()
			end
		end)
	end
end

return function(scene)
	local subject = scene.Camera.Subject
	local maxDistance = math.huge
	local targetProximityPrompt = nil
	local promptCount = 0

	table.clear(proximityPrompts)
	table.clear(proximityInRange)

	if not subject or not subject.Instance then
		return
	end

	local subjectPos = subject.Instance.AbsolutePosition
	for _, object in scene.Objects do
		if not object:IsA("ProximityPrompt2D") or not object.Enabled or not object.Instance then
			continue
		end

		local objectPos = object.Instance.AbsolutePosition
		local range = object.Range and object.Range * object.Range
		local distance = getDistance(subjectPos, objectPos)
		local inRange = distance <= (range or math.huge)

		promptCount += 1
		proximityPrompts[promptCount] = object
		proximityInRange[object] = inRange

		if distance < maxDistance and inRange then
			maxDistance = distance
			targetProximityPrompt = object
		end
	end

	for _, object in proximityPrompts do
		local inRange = proximityInRange[object]
		local isClosest = object == targetProximityPrompt
		local wasVisible = object.InRange == true and (object.IsClosest or not object.ShowIfClosest) or false
		local visible = inRange and (isClosest or not object.ShowIfClosest) or false

		object.InRange = inRange
		object.IsClosest = isClosest

		if wasVisible ~= visible then
			setProximityPromptVisible(object, visible)
		end
	end
end

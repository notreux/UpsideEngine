local TweenService = game:GetService("TweenService")
local getDistance = require(script.Parent.Parent.Parent.Lib.Util.Math.GetDistance)

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
	local proximityPrompts = {}

	if not subject and subject.Instance then
		return
	end

	for _, object in scene.Objects do
		if not object:IsA("ProximityPrompt2D") or not object.Enabled then
			continue
		end

		local subjectPos = subject.Instance.AbsolutePosition
		local objectPos = object.Instance and object.Instance.AbsolutePosition

		local range = object.Range and object.Range * object.Range
		local distance = getDistance(subjectPos, objectPos)

		local inRange = distance <= (range or math.huge)
		table.insert(proximityPrompts, {
			object = object,
			inRange = inRange,
		})

		if distance < maxDistance and inRange then
			maxDistance = distance
			targetProximityPrompt = object
		end
	end

	for _, data in proximityPrompts do
		local object = data.object
		local show = if object ~= targetProximityPrompt then not object.ShowIfClosest else true
		local closestChange = object.ShowIfClosest and object ~= targetProximityPrompt
		object.InRange = data.inRange
		object.IsClosest = object == targetProximityPrompt

		if object.inRange ~= data.inRange or closestChange then
			setProximityPromptVisible(object, object.InRange and show)
		end
	end
end

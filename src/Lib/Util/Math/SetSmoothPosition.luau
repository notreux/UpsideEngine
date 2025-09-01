return function(object: PhysicalObject, smoothness: number, target: UDim2)
	local alpha = 1 - math.clamp(smoothness, 0, 0.95)
	local instance = object.Instance :: ImageLabel

	local currentPosition = instance.Position
	instance.Position = currentPosition:Lerp(target, alpha)
end

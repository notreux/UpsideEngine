return function(v1, v2)
	local direction = v1 - v2
	return direction:Dot(direction)
end

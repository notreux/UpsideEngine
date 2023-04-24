return function(t1, t2)
	local result = t2 or {}
	for index, value in t1 do
		result[index] = value
	end

	return result
end

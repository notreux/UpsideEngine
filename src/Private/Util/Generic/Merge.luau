return function(t1, t2)
	local result = t1
	for index, value in t2 do
		result[index] = value
	end

	return result
end

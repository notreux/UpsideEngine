function isEqual(first, second)
	if first == second then
		return true
	elseif
		first == nil
		or second == nil
		or typeof(first) ~= typeof(second)
		or typeof(first) ~= "table" and typeof(second) ~= "table"
	then
		return false
	end

	local firstCount, secondCount = 0, 0
	for key, value in first do
		firstCount += 1
		if not isEqual(value, second[key]) then
			return false
		end
	end

	for _ in second do
		secondCount += 1
	end

	return firstCount == secondCount
end

return isEqual

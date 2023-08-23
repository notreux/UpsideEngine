function isEqual(first: table, second: table)
	if first == nil or typeof(second) ~= "table" then
		return first == second
	end

	for index, value in second do
		local areTheSame = isEqual(first[index], value)
		if not areTheSame then
			return false
		end
	end

	return true
end

return isEqual

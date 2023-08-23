function copyTable(__table, copyIn)
	local copy = copyIn or {}

	for key, value in __table do
		local valueType = typeof(value)

		if valueType ~= "table" then
			copy[key] = value
		else
			copy[key] = copyTable(value, copy[key])
		end
	end

	return copy
end

return copyTable

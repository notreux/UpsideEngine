local function diff(newObj, oldObj)
	local changes = {}
	for key, newVal in newObj do
		local oldVal = oldObj[key]
		if type(newVal) == "table" and type(oldVal) == "table" then
			local subChanges = diff(newVal, oldVal)

			if next(subChanges) then
				changes[key] = subChanges
			end
		elseif newVal ~= oldVal then
			changes[key] = newVal
		end
	end

	return changes
end

return diff

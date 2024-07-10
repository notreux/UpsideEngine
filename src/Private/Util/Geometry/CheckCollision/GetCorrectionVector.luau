local support = require(script.Parent.Support)
local function getEdge(simplex)
	local minDist = math.huge
	local edgeNormal = Vector3.zero
	local index = -1

	for i = 1, #simplex do
		local j = (i % #simplex) + 1
		local edge = simplex[j] - simplex[i]
		local normal = Vector3.new(-edge.Y, edge.X).Unit
		normal = if normal.Magnitude ~= 0 then normal else Vector3.new(1, 0, 0)

		local dist = normal:Dot(simplex[i])
		if dist < minDist then
			minDist = dist
			edgeNormal = normal
			index = j
		end
	end

	return index, edgeNormal
end

return function(simplex, objectA, objectB)
	for _ = 1, 4000 do
		local index, edgeNormal = getEdge(simplex)
		local support = support(objectA, edgeNormal) - support(objectB, -edgeNormal)
		local distance = edgeNormal:Dot(support)

		if distance - edgeNormal:Dot(simplex[index]) < 0.001 then
			return edgeNormal, distance
		end

		table.insert(simplex, index, support)
	end

	return Vector3.zero, Vector3.zero
end

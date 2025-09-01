local supportFn = require(script.Parent.Support)

local function getEdge(simplex)
	local minDistSq = math.huge
	local edgeNormal = Vector3.zero
	local index = -1
	local n = #simplex
	
	if n == 0 then
		return index, edgeNormal
	end

	for i = 1, n do
		local j = (i % n) + 1
		local edge = simplex[j] - simplex[i]
		local normal = Vector3.new(-edge.Y, edge.X)
		local magSq = normal.X * normal.X + normal.Y * normal.Y
		if magSq > 1e-12 then
			local dot = normal:Dot(simplex[i])
			local distSq = (dot * dot) / magSq
			if distSq < minDistSq then
				minDistSq = distSq
				edgeNormal = normal
				index = j
			end
		end
	end

	if index ~= -1 then
		local magSq = edgeNormal.X * edgeNormal.X + edgeNormal.Y * edgeNormal.Y
		if magSq > 1e-12 then
			local invMag = 1 / math.sqrt(magSq)
			edgeNormal = edgeNormal * invMag
		else
			edgeNormal = Vector3.new(1, 0, 0)
		end
	end

	return index, edgeNormal
end

return function(simplex, objectA, objectB)
	local eps = 1e-4
	for _ = 1, 64 do
		local index, edgeNormal = getEdge(simplex)
		if index == -1 then
			return Vector3.zero, 0
		end

		local supportPoint = supportFn(objectA, edgeNormal) - supportFn(objectB, -edgeNormal)
		local distance = edgeNormal:Dot(supportPoint)
		local edgePointDistance = edgeNormal:Dot(simplex[index])

		if distance - edgePointDistance < eps then
			return edgeNormal, distance
		end

		table.insert(simplex, index, supportPoint)
	end

	return Vector3.zero, 0
end

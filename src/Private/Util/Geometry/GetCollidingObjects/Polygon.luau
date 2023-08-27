local getCorners = require(script.Parent.Parent.GetCorners)
local function perpendicular(vec)
	return Vector2.new(-vec.Y, vec.X).Unit
end

local function projectPolygon(polygon, axis)
	local min = polygon[1]:Dot(axis)
	local max = min

	for i = 2, #polygon do
		local p = polygon[i]:Dot(axis)
		if p < min then
			min = p
		elseif p > max then
			max = p
		end
	end

	return min, max
end

local function sortf(a, b)
	return a.Magnitude < b.Magnitude
end

local function collide(self, object)
	local hbx = getCorners(self)
	local hbx2 = getCorners(object)

	local mtvs = {}
	for i = 1, #hbx do
		local nextIndex = i + 1 <= #hbx and i + 1 or 1
		local edge = hbx[nextIndex] - hbx[i]
		local axis = perpendicular(edge)

		local minA, maxA = projectPolygon(hbx, axis)
		local minB, maxB = projectPolygon(hbx2, axis)

		if not (minA <= maxB and minB <= maxA) then
			return false
		end

		local overlap = maxA > maxB and -(maxB - minA) or (maxA - minB)
		table.insert(mtvs, axis * overlap)
	end

	for i = 1, #hbx2 do
		local nextIndex = i + 1 <= #hbx2 and i + 1 or 1
		local edge = hbx2[nextIndex] - hbx2[i]
		local axis = perpendicular(edge)

		local minA, maxA = projectPolygon(hbx, axis)
		local minB, maxB = projectPolygon(hbx2, axis)

		if not (minA <= maxB and minB <= maxA) then
			return false
		end

		local overlap = maxA > maxB and -(maxB - minA) or (maxA - minB)
		table.insert(mtvs, axis * overlap)
	end

	table.sort(mtvs, sortf)
	return true, mtvs[1]
end

return collide

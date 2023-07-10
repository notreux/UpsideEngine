local getCorners = require(script.Parent.Parent.GetCorners)

local function minAndmaxV2(arr)
	local max = -math.huge
	local min = math.huge

	local minV2
	local maxV2

	for _, v2 in ipairs(arr) do
		local op = v2.X + v2.Y
		if op > max then
			max = op
			maxV2 = v2
		end

		if op < min then
			min = op
			minV2 = v2
		end
	end

	return minV2, maxV2
end

local function sortf(a, b)
	return a.Magnitude < b.Magnitude
end

local function getAxis(c1, c2)
	return {
		(c1[2] - c1[1]).Unit,
		(c1[4] - c1[1]).Unit,
		(c2[2] - c2[1]).Unit,
		(c2[4] - c2[1]).Unit,
	}
end

local function collide(self, object)
	local c1, c2 = getCorners(self), getCorners(object)
	local axis, mtvs = getAxis(c1, c2), {}

	local c1min, c1max = minAndmaxV2(c1)
	local c2min, c2max = minAndmaxV2(c2)

	for i = 1, #axis do
		local s1max, s1min = axis[i]:Dot(c1max), axis[i]:Dot(c1min)
		local s2max, s2min = axis[i]:Dot(c2max), axis[i]:Dot(c2min)

		if s2min > s1max or s2max < s1min then
			return
		end

		local overlap = s1max > s2max and -(s2max - s1min) or (s1max - s2min)
		table.insert(mtvs, axis[i] * overlap)
	end

	table.sort(mtvs, sortf)
	return true, mtvs[1]
end

return collide

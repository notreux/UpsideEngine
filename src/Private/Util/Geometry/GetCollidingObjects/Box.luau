local getCorners = require(script.Parent.Parent.GetCorners)

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

	for i = 1, #axis do
		local s1, s2 = {}, {}
		for n = 1, 4 do
			table.insert(s1, axis[i]:Dot(c1[n]))
			table.insert(s2, axis[i]:Dot(c2[n]))
		end

		local s1max, s1min = math.max(unpack(s1)), math.min(unpack(s1))
		local s2max, s2min = math.max(unpack(s2)), math.min(unpack(s2))

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

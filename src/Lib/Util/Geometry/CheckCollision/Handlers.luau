local handlers = {}

local function tripleProduct(a, b, c)
	return b * a:Dot(c) - a * b:Dot(c)
end

function handlers.point(direction, simplex)
	return -direction
end

function handlers.line(direction, simplex)
	local b = simplex[2]
	local c = simplex[1]

	local cb = b - c
	local c0 = -c

	return tripleProduct(cb, c0, cb)
end

function handlers.triangle(direction, simplex)
	local a = simplex[3]
	local b = simplex[2]
	local c = simplex[1]

	local a0 = -a
	local ab = b - a
	local ac = c - a

	local abPerp = tripleProduct(ac, ab, ab)
	local acPerp = tripleProduct(ab, ac, ac)

	if abPerp:Dot(a0) > 0 then
		table.remove(simplex, 1)
		return abPerp
	elseif acPerp:Dot(a0) > 0 then
		table.remove(simplex, 2)
		return acPerp
	end

	return direction, true
end

return handlers

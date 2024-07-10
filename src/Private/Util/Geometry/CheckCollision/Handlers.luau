type collision = nil | true

local handlers = {}
function tripleProduct(a, b, c)
	return a:Cross(b):Cross(c)
end

function handlers.point(direction, simplex): (Vector3, collision)
	return -direction
end

function handlers.line(direction, simplex): (Vector3, collision)
	local b = simplex[2]
	local c = simplex[1]

	local cb = b - c
	local c0 = c * -1

	return tripleProduct(cb, c0, cb)
end

function handlers.triangle(direction, simplex): (Vector3, collision)
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
		direction = abPerp
	elseif acPerp:Dot(a0) > 0 then
		table.remove(simplex, 2)
		direction = acPerp
	else
		return direction, true
	end

	return direction
end

return handlers

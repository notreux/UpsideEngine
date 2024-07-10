local getCorrectionVector = require(script.GetCorrectionVector)
local support = require(script.Support)
local handlers = require(script.Handlers)
local handlerNames = { "point", "line", "triangle" }
local EvolveResult = {
	NoIntersection = 1,
	Intersection = 2,
	Evolving = 3,
}

type EvolveResult = typeof(EvolveResult)
function toVector2(v3)
	return Vector2.new(v3.X, v3.Y)
end

function handleSimplex(data, objectA, objectB): EvolveResult
	local simplex = data.simplex
	local direction = data.direction

	local length = #simplex
	local collision = false

	if length > 0 then
		local handler = handlers[handlerNames[length]]
		direction, collision = handler(direction, simplex)
	end

	local newVertex = support(objectA, direction) - support(objectB, -1 * direction)
	local isEvolving = direction:Dot(newVertex) > 0

	data.direction = direction
	table.insert(simplex, newVertex)

	return if collision
		then EvolveResult.Intersection
		elseif isEvolving then EvolveResult.Evolving
		else EvolveResult.NoIntersection
end

return function(objectA, objectB): boolean
	local state = EvolveResult.Evolving
	local direction = objectA.centre - objectB.centre

	local data = {
		simplex = {},
		direction = if direction.Y == 0 then Vector3.one else direction,
	}

	while state == EvolveResult.Evolving do
		state = handleSimplex(data, objectA, objectB)
	end

	if state == EvolveResult.Intersection then
		local penetrationVector, penetrationDepth = getCorrectionVector(data.simplex, objectA, objectB)
		local unitDirection = penetrationVector.Unit
		unitDirection = if unitDirection.X ~= unitDirection.X then Vector3.zero else unitDirection

		local moveVector = unitDirection * penetrationDepth
		moveVector = toVector2(moveVector)

		return true, moveVector
	end

	return false
end

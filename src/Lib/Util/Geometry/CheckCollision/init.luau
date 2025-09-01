local getCorrectionVector = require(script.GetCorrectionVector)
local support = require(script.Support)
local handlers = require(script.Handlers)

local handlersByLen = {
	handlers.point,
	handlers.line,
	handlers.triangle,
}

local EvolveResult = {
	NoIntersection = 1,
	Intersection = 2,
	Evolving = 3,
}

type EvolveResult = typeof(EvolveResult)
local function toVector2(v3)
	return Vector2.new(v3.X, v3.Y)
end

local function handleSimplex(data, objectA, objectB)
	local simplex = data.simplex
	local direction = data.direction
	local length = #simplex

	if length > 0 then
		local handler = handlersByLen[length]
		if handler then
			local newDir, collision = handler(direction, simplex)
			if newDir then
				direction = newDir
			end

			if collision then
				data.direction = direction
				return EvolveResult.Intersection
			end
		end
	end

	local newVertex = support(objectA, direction) - support(objectB, -direction)
	local isEvolving = direction:Dot(newVertex) > 0

	data.direction = direction
	table.insert(simplex, newVertex)

	if isEvolving then
		return EvolveResult.Evolving
	else
		return EvolveResult.NoIntersection
	end
end

return function(objectA, objectB)
	local state = EvolveResult.Evolving
	local direction = objectA.centre - objectB.centre

	if direction.X == 0 and direction.Y == 0 then
		direction = Vector3.new(1, 0, 0)
	end

	local data = {
		simplex = {},
		direction = direction,
	}

	local iterations = 0
	local maxIterations = 64

	while state == EvolveResult.Evolving and iterations < maxIterations do
		state = handleSimplex(data, objectA, objectB)
		iterations = iterations + 1
	end

	if state == EvolveResult.Intersection then
		local penetrationVector, penetrationDepth = getCorrectionVector(data.simplex, objectA, objectB)

		if typeof(penetrationDepth) ~= "number" then
			penetrationDepth = 0
		end

		if penetrationVector.X == 0 and penetrationVector.Y == 0 or penetrationDepth == 0 then
			return true, Vector2.zero
		end

		local unitDirection = penetrationVector.Unit
		if unitDirection.X == 0 and unitDirection.Y == 0 or unitDirection.X ~= unitDirection.X then
			unitDirection = Vector3.zero
		end

		local moveVector = unitDirection * penetrationDepth
		moveVector = toVector2(moveVector)

		return true, moveVector
	end

	return false
end

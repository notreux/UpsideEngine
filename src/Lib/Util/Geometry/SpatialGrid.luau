--!native
--!optimize 2

local SpatialGrid = {}
SpatialGrid.__index = SpatialGrid

function SpatialGrid.new(cellSize: number)
	return setmetatable({
		_cellSize = cellSize,
		_cells = {},
	}, SpatialGrid)
end

function SpatialGrid:clear()
	for _, row in self._cells do
		for _, cell in row do
			table.clear(cell)
		end
	end
end

function SpatialGrid:insert(object)
	local pos = object.Instance.AbsolutePosition
	local size = object.Instance.AbsoluteSize
	local cs = self._cellSize

	local minCX = math.floor(pos.X / cs)
	local minCY = math.floor(pos.Y / cs)
	local maxCX = math.floor((pos.X + size.X) / cs)
	local maxCY = math.floor((pos.Y + size.Y) / cs)

	local cells = self._cells
	for cx = minCX, maxCX do
		local row = cells[cx]
		if not row then
			row = {}
			cells[cx] = row
		end
		for cy = minCY, maxCY do
			local cell = row[cy]
			if not cell then
				cell = {}
				row[cy] = cell
			end
			table.insert(cell, object)
		end
	end
end

function SpatialGrid:query(object, result, seen)
	table.clear(result)
	table.clear(seen)

	local pos = object.Instance.AbsolutePosition
	local size = object.Instance.AbsoluteSize
	local cs = self._cellSize

	local minCX = math.floor(pos.X / cs) - 1
	local minCY = math.floor(pos.Y / cs) - 1
	local maxCX = math.floor((pos.X + size.X) / cs) + 1
	local maxCY = math.floor((pos.Y + size.Y) / cs) + 1

	local cells = self._cells
	local n = 0

	for cx = minCX, maxCX do
		local row = cells[cx]
		if row then
			for cy = minCY, maxCY do
				local cell = row[cy]
				if cell then
					for _, other in cell do
						local id = other.Id
						if not seen[id] then
							seen[id] = true
							n += 1
							result[n] = other
						end
					end
				end
			end
		end
	end

	return result
end

return SpatialGrid

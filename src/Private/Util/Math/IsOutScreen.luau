return function(position, size)
	local resolution = workspace.CurrentCamera.ViewportSize
	local fakeRes = resolution + size
    -- stylua: ignore start
	return position.X < -size.X 
        or position.Y < -size.Y 
        or position.X > fakeRes.X 
        or position.Y > fakeRes.Y
	-- stylua: ignore end
end

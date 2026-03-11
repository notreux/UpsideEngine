local setSmoothPosition = require(script.Parent.Parent.Parent.Lib.Util.Math.SetSmoothPosition)
return function(scene: Scene)
	local camera = scene.Camera
	local subject = camera.Subject and camera.Subject.Instance
	if not subject then
		return
	end

	for _, parallax in scene.Objects.Content do
		if not parallax:IsA("Parallax") and not parallax.Track then
			continue
		end

		parallax:UpdateTiles()

		if not parallax.LockToCamera then
			continue
		end

		local position = subject.Position - camera.OffsetPosition
		setSmoothPosition(parallax, camera.Smoothness, position)
	end
end

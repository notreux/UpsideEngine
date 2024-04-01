local setSmoothPosition = require(script.Parent.Parent.Parent.Private.Util.Math.SetSmoothPosition)
return function(scene: Scene)
	local camera = scene.Camera
	local subject = camera.Subject.Instance

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

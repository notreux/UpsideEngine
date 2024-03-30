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

		local instance = parallax.Instance
		local position = subject.Position - camera.OffsetPosition
		instance.Position = position
	end
end

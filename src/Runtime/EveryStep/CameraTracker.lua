return function(scene, deltaTime)
	local camera = scene.Camera
	if not camera.Subject or not camera.FollowSubject then
		return
	end

	camera:LookTo(camera.Subject)
end

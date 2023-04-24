local util = require(script.Parent.Parent.Parent.Private.Util)
local normalize = util.Normalize

return function(scene)
	if not scene.Camera.Subject then
		return
	end

	for _, sound in scene.SoundEnvironment.Content do
		local soundSubject = sound.Subject.Instance
		local soundInstance = sound.Instance

		local player = scene.Camera.Subject.Instance
		local distance = (player.AbsolutePosition - soundSubject.AbsolutePosition).Magnitude

		if distance <= sound.Range and sound.DistanceFading then
			soundInstance.Volume = sound.MaxVolume - normalize(distance, 0, sound.Range)
		elseif distance <= sound.Range then
			soundInstance.Volume = sound.MaxVolume
		elseif sound.Volume ~= 0 then
			soundInstance.Volume = 0
		end
	end
end

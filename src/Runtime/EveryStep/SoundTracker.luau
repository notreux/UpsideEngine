local util = require(script.Parent.Parent.Parent.Lib.Util)
local getDistance = require(script.Parent.Parent.Parent.Lib.Util.Math.GetDistance)
local normalize = util.Normalize

return function(scene)
	if not scene.Camera.Subject then
		return
	end

	for _, sound in scene.SoundEnvironment.Content do
		local soundSubject = sound.Subject.Instance
		local soundInstance = sound.Instance

		local player = scene.Camera.Subject.Instance
		local range = sound.Range * sound.Range
		local distance = getDistance(player.AbsolutePosition, soundSubject.AbsolutePosition)

		if distance <= range and sound.DistanceFading then
			soundInstance.Volume = sound.MaxVolume - normalize(distance, 0, range)
		elseif distance <= range then
			soundInstance.Volume = sound.MaxVolume
		elseif sound.Volume ~= 0 then
			soundInstance.Volume = 0
		end
	end
end
